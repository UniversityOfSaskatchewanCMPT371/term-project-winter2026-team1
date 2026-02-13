import 'package:powersync/powersync.dart';
import 'database/powersync.dart';
import 'database/schema.dart';
import 'utils/constants.dart';

// The main injection
Future<void> initInjections() async {
  await initDatabases();
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