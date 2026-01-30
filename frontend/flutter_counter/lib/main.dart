import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supabase_template/utils/injections.dart';
import 'package:logging/logging.dart';
import 'features/counter/presentation/bloc/counter_page_bloc.dart';
import 'features/counter/presentation/pages/counter_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'utils/constants.dart';

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

  await Future.delayed(Duration(seconds: 5));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => getIt<CounterPageBloc>(),
        child: CounterPage(),
      ),
    );
  }
}
