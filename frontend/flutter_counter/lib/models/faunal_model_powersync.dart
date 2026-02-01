import 'package:powersync/sqlite3_common.dart' as sqlite;

class FaunalModelPowersync {
  final int id;
  final String site;
  final String unit;
  final int yearOfAnalysis;
  final String bone;
  final String? description;
  
  FaunalModelPowersync({
    required this.id,
    required this.site,
    required this.unit,
    required this.yearOfAnalysis,
    required this.bone,
    this.description,
  }) : assert(site.trim().isNotEmpty),
       assert(unit.trim().isNotEmpty),
       assert(yearOfAnalysis >= 0),
       assert(bone.trim().isNotEmpty),
       assert(description == null || description.trim().isNotEmpty);

  factory FaunalModelPowersync.fromRow(sqlite.Row row) {
    int asInt(dynamic v) => v is int ? v : int.parse(v.toString());
    String? nullable(dynamic v) => v == null ? null : v.toString();

    return FaunalModelPowersync(
      id: asInt(row['id']), 
      site: row['site'].toString(), 
      unit: row['unit'].toString(), 
      yearOfAnalysis: asInt(row['year_of_analysis']), 
      bone: row['bone'].toString(),
      description: (() {
        final d = nullable(row['description']);
        if (d == null || d.trim().isEmpty) return null;
        return d;
      })(),
    );
  }
}



