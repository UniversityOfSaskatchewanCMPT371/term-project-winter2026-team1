import 'package:flutter/foundation.dart';
import 'package:powersync/powersync.dart';

import 'database/powersync.dart';
import 'database/schema.dart';
import 'utils/constants.dart';

// Made a few changes here will modify later
Future<void> initInjections() async {
  await initDatabases();
}

Future<void> initDatabases() async {
  if (kIsWeb) {
    return;
  }

  if (!getIt.isRegistered<PowerSyncDatabase>()) {
    getIt.registerSingleton<PowerSyncDatabase>(
      PowerSyncDatabase(
        schema: schema,
        path: await getDatabasePath(),
        logger: attachedLogger,
      ),
    );
  }

  await openDatabase(getIt<PowerSyncDatabase>());
}
