import 'package:powersync/powersync.dart';
import 'package:search_cms/features/area/area_injections.dart';
import 'package:search_cms/features/authentication/authentication_injections.dart';
import 'package:search_cms/features/site/site_injections.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'database/powersync.dart';
import 'database/schema.dart';
import 'utils/constants.dart';

/*
  The overall application dependency injections setup.
  Remember to add your new feature injections here.
 */
Future<void> initInjections() async {
  await initDatabases();
  initAuthenticationInjections();
  initSiteInjections();
  initAreaInjections();
}

/*
  Register how the database should be constructed.
  And finally init PowerSync, and PowerSync will init Supabase.

  Postcondition: The getIt template for both databases are defined &&
    Supabase and PowerSync are initialized.
 */
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
