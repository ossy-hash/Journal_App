import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/journal_model.dart';
import '../../providers/journal_provider.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/journal_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(journalProvider).favorites;

    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/'),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.star_rounded,
              color: AppTheme.goldAccent,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text('Favorites'),
          ],
        ),
      ),
      body: favorites.isEmpty
          ? _buildEmptyState(context)
          : _buildFavoritesGrid(context, favorites, ref),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.star_outline_rounded,
      title: 'No Favorites Yet',
      subtitle: 'Mark journals as favorites to see them here',
    );
  }

  Widget _buildFavoritesGrid(
    BuildContext context,
    List<JournalModel> favorites,
    WidgetRef ref,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        return JournalCard(
          journal: favorites[index],
          onTap: () => context.go('/journal/${favorites[index].id}'),
          onFavoriteToggle: () {
            ref
                .read(journalProvider.notifier)
                .toggleFavorite(favorites[index].id);
          },
        );
      },
    );
  }
}