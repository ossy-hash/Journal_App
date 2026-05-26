import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/journal_model.dart';
import 'local_storage_service.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final LocalStorageService _localStorage = LocalStorageService();
  
  // Create new journal entry
  Future<JournalModel> createJournal(JournalModel journal) async {
    try {
      // Save locally first
      await _localStorage.saveJournal(journal);
      
      // Try to sync with cloud
      final response = await _supabase
          .from('journals')
          .insert(journal.toJson())
          .select()
          .single();
      
      final syncedJournal = JournalModel.fromJson(response);
      await _localStorage.updateSyncStatus(journal.id, true);
      return syncedJournal;
    } catch (e) {
      // Return local version if sync fails
      return journal;
    }
  }
  
  // Get all journals for user
  Future<List<JournalModel>> getJournals(String userId) async {
    try {
      // Fetch from cloud
      final response = await _supabase
          .from('journals')
          .select()
          .eq('user_id', userId)
          .order('updated_at', ascending: false);
      
      final journals = response
          .map<JournalModel>((json) => JournalModel.fromJson(json))
          .toList();
      
      // Update local cache
      await _localStorage.cacheJournals(journals);
      
      return journals;
    } catch (e) {
      // Fallback to local cache
      return _localStorage.getCachedJournals(userId);
    }
  }
  
  // Update journal
  Future<JournalModel> updateJournal(JournalModel journal) async {
    try {
      await _localStorage.saveJournal(journal);
      
      final response = await _supabase
          .from('journals')
          .update(journal.toJson())
          .eq('id', journal.id)
          .select()
          .single();
      
      return JournalModel.fromJson(response);
    } catch (e) {
      return journal;
    }
  }
  
  // Delete journal
  Future<void> deleteJournal(String journalId) async {
    await _localStorage.deleteJournal(journalId);
    
    try {
      await _supabase
          .from('journals')
          .delete()
          .eq('id', journalId);
    } catch (e) {
      // Will sync deletion when connection is restored
    }
  }
  
  // Toggle favorite
  Future<void> toggleFavorite(String journalId, bool isFavorite) async {
    await _localStorage.toggleFavorite(journalId, isFavorite);
    
    try {
      await _supabase
          .from('journals')
          .update({'is_favorite': isFavorite})
          .eq('id', journalId);
    } catch (e) {
      // Will sync when connection is restored
    }
  }
}