import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
// import 'package:powersync/powersync.dart';
// import 'package:provider/provider.dart';

// import './powersync.dart';
// import './widgets/status_app_bar.dart';
// import './widgets/status_section.dart';
// import './widgets/counters_list.dart';

import './supabase.dart';
import 'faunal_spike.dart';
import 'faunal_spike_powersync.dart';
import 'powersync_faunal.dart';

const bool usePowerSync = true; // Flip false

void main() async {
  // Set up logging for debugging
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print(
        '[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}',
      );

      if (record.error != null) {
        print(record.error);
      }
      if (record.stackTrace != null) {
        print(record.stackTrace);
      }
    }
  });

  WidgetsFlutterBinding.ensureInitialized();

  await loadSupabase();

  // Initialize database before starting the app
  // final database = await openDatabase();

  if (usePowerSync) {
    final db = await openFaunalDatabase();
    runApp(FaunalSpikePowerSync(database: db));
  } else {
    runApp(const SpikeApp());
  }
}




