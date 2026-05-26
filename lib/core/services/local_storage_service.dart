import 'package:hive/hive.dart';
import '../models/journal_model.dart';

class LocalStorageService {
  late Box _journalBox;
  late Box _cacheBox;
  late Box _prefsBox;
  
  LocalStorageService() {
    _journalBox = Hive.box('journals');
    _cacheBox = Hive.box('journal_cache');
    _prefsBox = Hive.box('user_preferences');
  }
  
  // Save journal locally
  Future<void> saveJournal(JournalModel journal) async {
    await _journalBox.put(journal.id, journal.toJson());
  }
  
  // Get cached journals
  Future<List<JournalModel>> getCachedJournals(String userId) async {
    final journals = _cacheBox.get('journals_$userId');
    if (journals != null) {
      return (journals as List)
          .map((json) => JournalModel.fromJson(json))
          .toList();
    }
    return [];
  }
  
  // Cache journals list
  Future<void> cacheJournals(List<JournalModel> journals) async {
    final jsonList = journals.map((j) => j.toJson()).toList();
    if (journals.isNotEmpty) {
      await _cacheBox.put('journals_${journals.first.userId}', jsonList);
    }
  }
  
  // Update sync status
  Future<void> updateSyncStatus(String journalId, bool isSynced) async {
    final journal = _journalBox.get(journalId);
    if (journal != null) {
      journal['is_synced'] = isSynced;
      await _journalBox.put(journalId, journal);
    }
  }
  
  // Delete journal
  Future<void> deleteJournal(String journalId) async {
    await _journalBox.delete(journalId);
  }
  
  // Toggle favorite
  Future<void> toggleFavorite(String journalId, bool isFavorite) async {
    final journal = _journalBox.get(journalId);
    if (journal != null) {
      journal['is_favorite'] = isFavorite;
      await _journalBox.put(journalId, journal);
    }
  }
  
  // Get pending syncs
  Future<List<JournalModel>> getPendingSyncs() async {
    final allJournals = _journalBox.values.toList();
    return allJournals
        .where((json) => json['is_synced'] == false)
        .map((json) => JournalModel.fromJson(json))
        .toList();
  }
  
  // User preferences
  Future<void> setPreference(String key, dynamic value) async {
    await _prefsBox.put(key, value);
  }
  
  dynamic getPreference(String key) {
    return _prefsBox.get(key);
  }
}