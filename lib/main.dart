import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('journals');
  await Hive.openBox('journal_cache');
  await Hive.openBox('prefs');
  await Hive.openBox('user_preferences');
  await Supabase.initialize(
    url: 'https://qdufvlgdlaxoogzuptbq.supabase.co',
    anonKey: 'sb_publishable_Szwl00WlH5q3uC2cTQu1RQ_ByTEytUu',
  );
  runApp(const ProviderScope(child: JournalApp()));
}
