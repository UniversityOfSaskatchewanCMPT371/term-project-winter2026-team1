import 'package:flutter/material.dart';
import 'package:powersync/powersync.dart' hide Column;

// ignore: unused_import
import './models/faunal_schema.dart';
import './models/faunal_model_powersync.dart';

class FaunalSpikePowerSync extends StatelessWidget {
  final PowerSyncDatabase database;
  const FaunalSpikePowerSync({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    FaunalPowerSyncPage.attachDatabase(database);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'sEARCH CMS Spike Prototype (PowerSync) with Sample Faunal Data',

      // Basic Material 3 theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),

      home: const FaunalPowerSyncPage(title: 'sEARCH CMS Spike Prototype (PowerSync) with Sample Faunal Data'),
    );
  }
}

class FaunalPowerSyncPage extends StatefulWidget {
  const FaunalPowerSyncPage({super.key, required this.title});
  final String title;

  @override
  State<FaunalPowerSyncPage> createState() => _FaunalPowerSyncPageState();

  // Static holder for the DB to keep things minimal for spike prototype
  static PowerSyncDatabase? psDB;
  static void attachDatabase(PowerSyncDatabase db) => psDB = db;
}

class _FaunalPowerSyncPageState extends State<FaunalPowerSyncPage> {
  PowerSyncDatabase get db => FaunalPowerSyncPage.psDB!;

  // Load data from PowerSync database
  Future<List<FaunalModelPowersync>> load() async {
    final rows = await db.getAll('''
      SELECT id, site, unit, year_of_analysis, bone, description
      FROM faunal_data
      ORDER BY id ASC
    ''');
    return rows.map(FaunalModelPowersync.fromRow).toList(growable: false);
  }

  // Add data to PowerSync database
  Future<void> insert({
    required String id,
    required String site,
    required String unit,
    required int yearOfAnalysis,
    required String bone,
    String? description,
  }) async {
    await db.execute(
      '''
      INSERT INTO faunal_data (id, site, unit, year_of_analysis, bone, description)
      VALUES (?, ?, ?, ?, ?, ?)
      ''',
      [
        id,
        site.trim(),
        unit.trim(),
        yearOfAnalysis,
        bone.trim(),
        (description == null || description.trim().isEmpty) ? null : description.trim(),
      ],
    );
  }

  // Dialog box for adding data
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
            )
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

                // Generate a numeric client ID
                final generatedId = DateTime.now().microsecondsSinceEpoch.toString();

                await insert(
                  id: generatedId,
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

      // Use to StreamBuilder to read data and display on startup
      body: StreamBuilder<List<FaunalModelPowersync>>(
        stream: db.watch('''
          SELECT id, site, unit, year_of_analysis, bone, description
          FROM faunal_data
          ORDER by id ASC
        ''').map((rows) => rows.map(FaunalModelPowersync.fromRow).toList(growable: false)),
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

      // body: FutureBuilder<List<FaunalModelPowersync>>(
      //   // The future we want to resolve (fetching faunal data)
      //   future: load(),
      //   builder: (context, snapshot) {

      //   // While waiting for the backend response
      //   if (snapshot.connectionState == ConnectionState.waiting) {
      //     return const Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   }

      //   // If something went wrong
      //   if (snapshot.hasError) {
      //     return Center(
      //       child: Text('Error: ${snapshot.error}'),
      //     );
      //   }

      //   // Data successfully received
      //   // If null, default to empty list
      //   final faunalData = snapshot.data ?? [];

      //   // If there are no data in the database
      //   if (faunalData.isEmpty) {
      //     return const Center(
      //       child: Text('No data found'),
      //     );
      //   }
        
      //   return SingleChildScrollView(
      //     scrollDirection: Axis.horizontal,
      //     child: DataTable(
      //       columns: const [
      //         DataColumn(label: Text('Site')),
      //         DataColumn(label: Text('Unit')),
      //         DataColumn(label: Text('Year')),
      //         DataColumn(label: Text('Bone')),
      //         DataColumn(label: Text('Description')),
      //       ], 
      //       rows: faunalData.map((faunal) {
      //         return DataRow(
      //           cells: [
      //             DataCell(Text(faunal.site)),
      //             DataCell(Text(faunal.unit)),
      //             DataCell(Text(faunal.yearOfAnalysis.toString())),
      //             DataCell(Text(faunal.bone)),
      //             DataCell(Text(faunal.description ?? '')),
      //           ],
      //         );
      //       }).toList(),
      //     ),
      //   );
      // },
      // ),

      // + button on the bottom right to add data
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}


