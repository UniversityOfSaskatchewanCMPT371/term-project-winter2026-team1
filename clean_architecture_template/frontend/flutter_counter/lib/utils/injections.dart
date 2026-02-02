import 'package:flutter_supabase_template/config/database/supabase.dart';
import 'package:flutter_supabase_template/features/counter/counter_injections.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase, SupabaseClient;

import 'constants.dart';

// The main injection
Future<void> initInjections() async {
  await initDatabases();
  initCounterInjections();
}

// Initialize database
Future<void> initDatabases() async {
  await loadSupabase();
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
}