import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:search_cms/config/routes/routes.dart';
import 'package:logging/logging.dart';
import 'core/injections.dart';

void main() async {
  // Set up logging for debugging
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print(
        '[${record.loggerName}] ${record.level.name}: ${record.time}: ${record
            .message}',
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

  // Initialize before starting the app
  await initInjections();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Counter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
