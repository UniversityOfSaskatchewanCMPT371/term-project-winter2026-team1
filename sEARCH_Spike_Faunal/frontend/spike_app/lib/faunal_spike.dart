import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import './models/faunal_model.dart';
// import 'supabase.dart';

// Global Supabase client instance
final supabase = Supabase.instance.client;

// Fetch data from Supabase
Future<List<FaunalModel>> fetchData() async {
  final response = await supabase
    .from('faunal_data')
    .select()
    .order('id', ascending: true);

  // Return raw rows as a list of maps
  return response
  .map<FaunalModel>((row) => FaunalModel.fromMap(row))
  .toList();
}

// Add data into Supabase
Future<void> addFaunalData({
  required String site,
  required String unit,
  required int yearOfAnalysis,
  required String bone,
  String? description,
}) async {

  // ===== Preconditions =====

  // Assertions
  // assert(site.trim().isNotEmpty, 'Site must not be empty');
  // assert(unit.trim().isNotEmpty, 'Unit must not be empty');
  // assert(bone.trim().isNotEmpty, 'Bone must not be empty');

  // Insert into Supabase
  await supabase.from('faunal_data').insert({
    'site': site,
    'unit': unit,
    'year_of_analysis': yearOfAnalysis,
    'bone': bone,
    'description': (description == null || description.trim().isEmpty) ? null : description.trim(),
  });
}

// Root widget of the app
class SpikeApp extends StatelessWidget {
  const SpikeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'sEARCH CMS Spike Prototype with Sample Faunal Data',

      // Basic Material 3 theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),

      home: const FaunalDataPage(title: 'sEARCH CMS Spike Prototype with Sample Faunal Data'),
    );
  }
}

// Home screen widget
class FaunalDataPage extends StatefulWidget {
  const FaunalDataPage({super.key, required this.title});

  final String title;

  @override
  State<FaunalDataPage> createState() => _FaunalDataPageState();
}

// State class for FaunalDataPage
class _FaunalDataPageState extends State<FaunalDataPage> {
  void _showAddDialog() {
    final siteController = TextEditingController();
    final unitController = TextEditingController();
    final yearController = TextEditingController();
    final boneController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Faunal Record'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: siteController,
                  decoration: const InputDecoration(labelText: 'Site'),
                ),
                TextField(
                  controller: unitController,
                  decoration: const InputDecoration(labelText: 'Unit'),
                ),
                TextField(
                  controller: yearController,
                  decoration: const InputDecoration(labelText: 'Year of Analysis'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: boneController,
                  decoration: const InputDecoration(labelText: 'Bone'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context), 
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                final site = siteController.text.trim();
                final unit = unitController.text.trim();
                final year = int.tryParse(yearController.text.trim());
                final bone = boneController.text.trim();

                if (site.isEmpty || unit.isEmpty || bone.isEmpty || year == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter Site, Unit, Bone, and a valid Year')),
                  );
                  return;
                }

                await addFaunalData(
                  site: site, 
                  unit: unit, 
                  yearOfAnalysis: year,
                  bone: bone,
                  description: descriptionController.text,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                  setState(() {}); // Refresh table
                }
              }, 
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: 
            FutureBuilder<List<FaunalModel>>(

              // The future we want to resolve (fetching faunal data)
              future: fetchData(),

              builder: (context, snapshot) {
                
                // While waiting for the backend response
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
            
                // If something went wrong
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                // Data successfully received
                // If null, default to empty list
                final faunalData = snapshot.data ?? [];

                // If there are no data in the database
                if (faunalData.isEmpty) {
                  return const Center(
                    child: Text('No data found'),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Site')),
                      DataColumn(label: Text('Unit')),
                      DataColumn(label: Text('Year')),
                      DataColumn(label: Text('Bone')),
                      DataColumn(label: Text('Description')),
                    ], 
                    rows: faunalData.map((faunal) {
                      return DataRow(
                        cells: [
                          DataCell(Text(faunal.site)),
                          DataCell(Text(faunal.unit)),
                          DataCell(Text(faunal.yearOfAnalysis.toString())),
                          DataCell(Text(faunal.bone)),
                          DataCell(Text(faunal.description ?? '')),
                        ],
                      );
                  }).toList(),
                ),
               );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}



