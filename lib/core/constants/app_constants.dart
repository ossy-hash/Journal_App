class AppConstants {
  // App Info
  static const String appName = 'Journal';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'A premium journaling experience';
  
  // Supabase
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  // Storage Keys
  static const String journalBox = 'journals';
  static const String cacheBox = 'journal_cache';
  static const String prefsBox = 'user_preferences';
  
  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 400);
  static const Duration slowAnimation = Duration(milliseconds: 800);
  
  // UI Constants
  static const double cardRadius = 16.0;
  static const double buttonRadius = 12.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  // Limits
  static const int maxTitleLength = 100;
  static const int maxTagsPerJournal = 10;
  static const int maxJournalsPerPage = 20;
  
  // Routes
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String forgotPasswordRoute = '/forgot-password';
  static const String homeRoute = '/';
  static const String editorRoute = '/journal';
  static const String settingsRoute = '/settings';
  static const String favoritesRoute = '/favorites';
}