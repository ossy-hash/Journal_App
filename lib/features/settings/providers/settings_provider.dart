import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../core/services/local_storage_service.dart';

class SettingsState {
  final bool isDarkMode;
  final bool autoSync;
  final String? lastSync;
  final double storageUsed;
  final bool notificationsEnabled;

  const SettingsState({
    this.isDarkMode = true,
    this.autoSync = true,
    this.lastSync,
    this.storageUsed = 0.0,
    this.notificationsEnabled = true,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    bool? autoSync,
    String? lastSync,
    double? storageUsed,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      autoSync: autoSync ?? this.autoSync,
      lastSync: lastSync ?? this.lastSync,
      storageUsed: storageUsed ?? this.storageUsed,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final LocalStorageService _localStorage;

  SettingsNotifier(this._localStorage) : super(const SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final isDarkMode =
        _localStorage.getPreference('isDarkMode') as bool? ?? true;
    final autoSync =
        _localStorage.getPreference('autoSync') as bool? ?? true;
    final lastSync =
        _localStorage.getPreference('lastSync') as String?;
    final storageUsed =
        (_localStorage.getPreference('storageUsed') as double?) ?? 0.0;

    state = SettingsState(
      isDarkMode: isDarkMode,
      autoSync: autoSync,
      lastSync: lastSync,
      storageUsed: storageUsed,
    );
  }

  Future<void> toggleDarkMode() async {
    final newValue = !state.isDarkMode;
    await _localStorage.setPreference('isDarkMode', newValue);
    state = state.copyWith(isDarkMode: newValue);
  }

  Future<void> toggleAutoSync() async {
    final newValue = !state.autoSync;
    await _localStorage.setPreference('autoSync', newValue);
    state = state.copyWith(autoSync: newValue);
  }

  Future<void> clearCache() async {
    final box = Hive.box('journal_cache');
    await box.clear();
    
    await _localStorage.setPreference('storageUsed', 0.0);
    state = state.copyWith(storageUsed: 0.0);
  }

  void updateLastSync(String time) {
    _localStorage.setPreference('lastSync', time);
    state = state.copyWith(lastSync: time);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final localStorage = LocalStorageService();
  return SettingsNotifier(localStorage);
});