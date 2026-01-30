import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:provider/provider.dart';

import './models/counter.dart';
import './powersync.dart';
import './widgets/status_app_bar.dart';
import './widgets/status_section.dart';
import './widgets/counters_list.dart';

import './supabase.dart';
import 'faunal_spike.dart';

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

  runApp(const SpikeApp());
}

class MyApp extends StatelessWidget {
  final PowerSyncDatabase database;

  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return Provider<PowerSyncDatabase>(
      create: (_) => database,
      dispose: (_, value) => value.close(),
      child: MaterialApp(
        title: 'PowerSync Counter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const CountersPage(),
      ),
    );
  }
}

/// Main page that displays the list of counters
class CountersPage extends StatelessWidget {
  const CountersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StatusAppBar(title: Text('Counter Demo')),
      body: const _HomeBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.createCounter();
        },
        tooltip: 'Add new counter',
        child: const Icon(Icons.add),
      ),
      // Simple drawer menu
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () async {
                Navigator.pop(context);
                final db = context.read<PowerSyncDatabase>();
                await logout(db);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        StatusSection(),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Counters',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8),
        SizedBox(height: 600, child: CountersList()),
      ],
    );
  }
}

