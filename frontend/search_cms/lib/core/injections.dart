import 'package:powersync/powersync.dart';
import 'package:search_cms/features/authentication/authentication_injections.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'database/powersync.dart';
import 'database/schema.dart';
import 'utils/constants.dart';

// Made a few changes here will modify later
Future<void> initInjections() async {
  await initDatabases();
  initAuthenticationInjections();
}

Future<void> initDatabases() async {
  if (!getIt.isRegistered<PowerSyncDatabase>()) {
    getIt.registerSingleton<PowerSyncDatabase>(
      PowerSyncDatabase(
        schema: schema,
        path: await getDatabasePath(),
        logger: attachedLogger,
      ),
    );
  }
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  await openDatabase(getIt<PowerSyncDatabase>());
}
