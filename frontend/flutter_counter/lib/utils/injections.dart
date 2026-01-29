import 'package:flutter_supabase_template/features/counter/counter_injections.dart';
import 'package:powersync/powersync.dart';
import '../config/database/powersync.dart' as power_sync show getDatabasePath, openDatabase;
import '../config/database/schema.dart' show schema;
import 'constants.dart';

Future<void> initInjections() async {
  await initDatabases();
  initCounterInjections();
}

Future<void> initDatabases() async {
  getIt.registerSingleton<PowerSyncDatabase>(PowerSyncDatabase(
      schema: schema,
      path: await power_sync.getDatabasePath(),
      logger: attachedLogger));
  await power_sync.openDatabase(getIt<PowerSyncDatabase>());
}