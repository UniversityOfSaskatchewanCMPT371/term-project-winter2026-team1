import 'package:flutter_supabase_template/config/database/powersync.dart';
import 'package:flutter_supabase_template/config/database/schema.dart';
import 'package:flutter_supabase_template/features/counter/counter_injections.dart';
import 'package:powersync/powersync.dart';
import 'constants.dart';

// The main injection
Future<void> initInjections() async {
  await initDatabases();
  initCounterInjections();
}

// Initialize database
Future<void> initDatabases() async {
  // Initialize database before starting the app
  getIt.registerSingleton<PowerSyncDatabase>(PowerSyncDatabase(
      schema: schema,
      path: await getDatabasePath(),
      logger: attachedLogger));
  await openDatabase(getIt<PowerSyncDatabase>());
}