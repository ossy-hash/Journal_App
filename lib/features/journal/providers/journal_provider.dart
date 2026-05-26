import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/journal_model.dart';
import '../../../core/services/database_service.dart';
import '../../auth/providers/auth_provider.dart';

// Journal state
class JournalState {
  final List<JournalModel> journals;
  final List<JournalModel> favorites;
  final bool isLoading;
  final String? error;
  final String? searchQuery;
  
  const JournalState({
    this.journals = const [],
    this.favorites = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery,
  });
  
  List<JournalModel> getFilteredJournals() {
    if (searchQuery == null || searchQuery!.isEmpty) return journals;
    final query = searchQuery!.toLowerCase();
    return journals.where((j) {
      return j.title.toLowerCase().contains(query) ||
          j.content.toLowerCase().contains(query) ||
          j.tags.any((t) => t.toLowerCase().contains(query));
    }).toList();
  }

  JournalState copyWith({
    List<JournalModel>? journals,
    List<JournalModel>? favorites,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return JournalState(
      journals: journals ?? this.journals,
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery,
    );
  }
}

// Journal notifier
class JournalNotifier extends StateNotifier<JournalState> {
  final DatabaseService _databaseService;
  final Ref _ref;
  
  JournalNotifier(this._databaseService, this._ref) 
      : super(const JournalState());
  
  // Load journals
  Future<void> loadJournals() async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return;
    
    state = state.copyWith(isLoading: true);
    
    try {
      final journals = await _databaseService.getJournals(user.id);
      final favorites = journals.where((j) => j.isFavorite).toList();
      
      state = state.copyWith(
        journals: journals,
        favorites: favorites,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  // Create journal
  Future<void> createJournal(JournalModel journal) async {
    final created = await _databaseService.createJournal(journal);
    final updatedJournals = [created, ...state.journals];
    
    state = state.copyWith(journals: updatedJournals);
  }
  
  // Update journal
  Future<void> updateJournal(JournalModel journal) async {
    final updated = await _databaseService.updateJournal(journal);
    final updatedJournals = state.journals.map((j) {
      return j.id == updated.id ? updated : j;
    }).toList();
    
    state = state.copyWith(journals: updatedJournals);
  }
  
  // Delete journal
  Future<void> deleteJournal(String journalId) async {
    await _databaseService.deleteJournal(journalId);
    final updatedJournals = state.journals
        .where((j) => j.id != journalId)
        .toList();
    
    state = state.copyWith(journals: updatedJournals);
  }
  
  // Toggle favorite
  Future<void> toggleFavorite(String journalId) async {
    final journal = state.journals.firstWhere((j) => j.id == journalId);
    final updatedJournal = journal.copyWith(isFavorite: !journal.isFavorite);
    
    await _databaseService.toggleFavorite(journalId, updatedJournal.isFavorite);
    
    final updatedJournals = state.journals.map((j) {
      return j.id == journalId ? updatedJournal : j;
    }).toList();
    
    final updatedFavorites = updatedJournals
        .where((j) => j.isFavorite)
        .toList();
    
    state = state.copyWith(
      journals: updatedJournals,
      favorites: updatedFavorites,
    );
  }
  
  // Search journals
  void searchJournals(String query) {
    if (query.isEmpty) {
      state = state.copyWith(searchQuery: null);
      return;
    }
    
    state = state.copyWith(searchQuery: query);
  }
  
}

// Providers
final journalProvider = 
    StateNotifierProvider<JournalNotifier, JournalState>((ref) {
  final databaseService = DatabaseService();
  return JournalNotifier(databaseService, ref);
});

final filteredJournalsProvider = Provider<List<JournalModel>>((ref) {
  final journalState = ref.watch(journalProvider);
  return journalState.getFilteredJournals();
});