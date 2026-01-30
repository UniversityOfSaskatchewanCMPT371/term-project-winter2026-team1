import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import './models/faunal_model.dart';
// import 'supabase.dart';

// Global Supabase client instance.
final supabase = Supabase.instance.client;

Future<List<FaunalModel>> fetchData() async {
  final response = await supabase
    .from('faunal_data')
    .select()
    .order('id');

  // Return raw rows as a list of maps
  return response
  .map<FaunalModel>((row) => FaunalModel.fromMap(row))
  .toList();
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
  State<FaunalDataPage> createState() => _FaunalDataPage();
}

// State class for FaunalDataPage
class _FaunalDataPage extends State<FaunalDataPage> {
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

                // Build a table of faunal data
                return ListView.builder(
                  itemCount: faunalData.length,
                  itemBuilder: (context, index) {
                    final FaunalModel faunalModel = faunalData[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Site: ${faunalModel.site}'),
                        Text('Unit: ${faunalModel.unit}'),
                        Text('YearOfAnalysis: ${faunalModel.yearOfAnalysis}'),
                        Text('Bone: ${faunalModel.bone}'),
                        Text('Description: ${faunalModel.description ?? ''}'),
                      ],
                    );
                  }
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}
