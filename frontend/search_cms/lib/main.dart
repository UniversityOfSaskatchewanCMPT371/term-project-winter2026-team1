import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'config/routes/routes.dart';
import 'core/injections.dart';

void main() async {

  if (kReleaseMode) {
    Logger.root.level = Level.OFF;
  } else {
    Logger.root.level = logLevel;
    Logger.root.onRecord.listen((record) {
      if (kDebugMode) {
        print('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
        if (record.error != null) {
          print(record.error);
        }
        if (record.stackTrace != null) {
          print(record.stackTrace);
        }
      }
    });
  }



  WidgetsFlutterBinding.ensureInitialized();

  // Made a few chnages here for creating the login page for now will change later
  await initInjections();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          routerConfig: router,
          title: 'sEARCH CMS',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
          ),
        );
      },
    );
  }
}
