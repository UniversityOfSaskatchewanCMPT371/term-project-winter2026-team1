import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_config.dart'; 

Future<void> main() async {
  // Make sure Flutter is ready before running async code
  WidgetsFlutterBinding.ensureInitialized();

  // Connect to Supabase using values from app_config.dart
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  runApp(const MyApp());
}

// Root app widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

// Main page for spike prototype
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Supabase client
  final supabase = Supabase.instance.client;

  // This starts the data visualization with the first row and then keeps adding one
  int visible = 1;

  // Holds rows we show in the table
  List<Map<String, dynamic>> rows = [];

  // Loads rows from the database
  //From the earliest data to the latest
  Future<void> load() async {
    final data = await supabase
        .from('sample_visualization')
        .select('id, site, unit, analysis_year, taxon')
        .order('id', ascending: true)
        .limit(visible);

    setState(() {
      rows = List<Map<String, dynamic>>.from(data);
    });
  }

  @override
  void initState() {
    super.initState();
    load(); //LOADS The first row first and then the next ones in one whole table
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // We have 2 buttons
            // - Insert Next Row: shows one more row from Supabase
            // - Remove Last Row: Removes one row from the latest(last)
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    visible++;
                    load();
                  },
                  child: const Text('Insert Next Row'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (visible > 1) visible--;
                    load();
                  },
                  child: const Text('Remove Last Row'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // DataTable to display the spike prototype data
            DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Site')),
                DataColumn(label: Text('Unit')),
                DataColumn(label: Text('Year')),
                DataColumn(label: Text('Taxon')),
              ],
              rows: rows
                  .map((r) => DataRow(cells: [
                        DataCell(Text(r['id'].toString())),
                        DataCell(Text(r['site'])),
                        DataCell(Text(r['unit'])),
                        DataCell(Text(r['analysis_year'].toString())),
                        DataCell(Text(r['taxon'])),
                      ]))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
