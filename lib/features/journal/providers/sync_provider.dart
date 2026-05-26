import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/local_storage_service.dart';


class SyncState {
  final bool isSyncing;
  final DateTime? lastSyncTime;
  final int pendingSyncCount;
  final String? error;

  const SyncState({
    this.isSyncing = false,
    this.lastSyncTime,
    this.pendingSyncCount = 0,
    this.error,
  });

  SyncState copyWith({
    bool? isSyncing,
    DateTime? lastSyncTime,
    int? pendingSyncCount,
    String? error,
  }) {
    return SyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      pendingSyncCount: pendingSyncCount ?? this.pendingSyncCount,
      error: error,
    );
  }
}

class SyncNotifier extends StateNotifier<SyncState> {
  final DatabaseService _databaseService;
  final LocalStorageService _localStorage;
  StreamSubscription? _connectivitySubscription;
  Timer? _syncTimer;

  SyncNotifier(
    this._databaseService,
    this._localStorage,
  ) : super(const SyncState()) {
    _initialize();
  }

  void _initialize() {
    // Listen for connectivity changes
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen(_handleConnectivityChange);

    // Periodic sync every 5 minutes
    _syncTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => syncData(),
    );

    // Initial sync
    syncData();
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    if (results.any((r) => r != ConnectivityResult.none)) {
      syncData();
    }
  }

  Future<void> syncData() async {
    if (state.isSyncing) return;

    state = state.copyWith(isSyncing: true, error: null);

    try {
      final connectivityResults = await Connectivity().checkConnectivity();
      if (connectivityResults.every((r) => r == ConnectivityResult.none)) {
        state = state.copyWith(
          isSyncing: false,
          pendingSyncCount: await _getPendingSyncCount(),
        );
        return;
      }

      // Get pending syncs
      final pendingJournals = await _localStorage.getPendingSyncs();
      state = state.copyWith(pendingSyncCount: pendingJournals.length);

      // Sync each journal
      for (final journal in pendingJournals) {
        try {
          await _databaseService.createJournal(journal);
          await _localStorage.updateSyncStatus(journal.id, true);
        } catch (e) {
          // Log error but continue with other journals
          continue;
        }
      }

      state = state.copyWith(
        isSyncing: false,
        lastSyncTime: DateTime.now(),
        pendingSyncCount: 0,
      );
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        error: e.toString(),
      );
    }
  }

  Future<int> _getPendingSyncCount() async {
    final pending = await _localStorage.getPendingSyncs();
    return pending.length;
  }

  Future<void> forceSync() async {
    await syncData();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _syncTimer?.cancel();
    super.dispose();
  }
}

final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  final databaseService = DatabaseService();
  final localStorage = LocalStorageService();
  return SyncNotifier(databaseService, localStorage);
});