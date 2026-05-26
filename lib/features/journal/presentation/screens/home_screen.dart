import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/journal_model.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../sidebar/presentation/widgets/sidebar_drawer.dart';
import '../../providers/journal_provider.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/journal_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(journalProvider.notifier).loadJournals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(journalProvider);
    final filteredJournals = ref.watch(filteredJournalsProvider);
    
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.primaryBlack,
      
      // Sidebar Drawer
      drawer: const SidebarDrawer(),
      
      // App Bar
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text('Ossy', style: TextStyle(color: AppTheme.goldAccent)),
        actions: [
          // Search Button
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              showSearch(
                context: context,
                delegate: JournalSearchDelegate(ref),
              );
            },
          ),
          // New Journal Button
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.goldAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.add_rounded,
                  color: AppTheme.primaryBlack,
                ),
                onPressed: () => context.go('/new'),
              ),
            ),
          ),
        ],
      ),
      
      // Floating Action Button
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.goldAccent.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => context.go('/new'),
          backgroundColor: AppTheme.goldAccent,
          foregroundColor: AppTheme.primaryBlack,
          icon: const Icon(Icons.auto_awesome),
          label: const Text('New Entry'),
        ),
      ),
      
      // Body
      body: state.isLoading
          ? _buildLoadingShimmer()
          : filteredJournals.isEmpty
              ? _buildEmptyState()
              : _buildJournalGrid(filteredJournals),
    );
  }
  
  Widget _buildLoadingShimmer() {
    return const LoadingShimmer();
  }
  
  Widget _buildEmptyState() {
    return EmptyStateWidget(
      icon: Icons.book_outlined,
      title: 'Start Your Journey',
      subtitle: 'Create your first journal entry',
      actionLabel: 'Create Entry',
      onAction: () => context.go('/new'),
    );
  }
  
  Widget _buildJournalGrid(List<JournalModel> journals) {
    return RefreshIndicator(
      onRefresh: () => ref.read(journalProvider.notifier).loadJournals(),
      color: AppTheme.goldAccent,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: journals.length,
        itemBuilder: (context, index) {
          return JournalCard(
            journal: journals[index],
            onTap: () => context.go('/journal/${journals[index].id}'),
            onFavoriteToggle: () {
              ref.read(journalProvider.notifier)
                  .toggleFavorite(journals[index].id);
            },
          );
        },
      ),
    );
  }
}

// Search Delegate
class JournalSearchDelegate extends SearchDelegate {
  final WidgetRef ref;
  
  JournalSearchDelegate(this.ref);
  
  @override
  String get searchFieldLabel => 'Search journals...';
  
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppTheme.primaryBlack,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: AppTheme.textSecondary),
        border: InputBorder.none,
      ),
    );
  }
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }
  
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }
  
  @override
  Widget buildResults(BuildContext context) {
    ref.read(journalProvider.notifier).searchJournals(query);
    return _buildSearchResults();
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {
    ref.read(journalProvider.notifier).searchJournals(query);
    return _buildSearchResults();
  }
  
  Widget _buildSearchResults() {
    final journals = ref.watch(filteredJournalsProvider);
    
    if (journals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No journals found',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: journals.length,
      itemBuilder: (context, index) {
        final journal = journals[index];
        return ListTile(
          title: Text(journal.title),
          subtitle: Text(
            journal.content.stripHtml().length > 100
                ? '${journal.content.stripHtml().substring(0, 100)}...'
                : journal.content.stripHtml(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppTheme.goldAccent,
          ),
          onTap: () {
            close(context, null);
            context.go('/journal/${journal.id}');
          },
        );
      },
    );
  }
}