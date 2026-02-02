class FaunalModel {
  final int id;
  final String site;
  final String unit;
  final int yearOfAnalysis;
  final String bone;
  final String? description;


// Invariants:
// - site, unit, yearOfAnalysis, and bone are non-empty
// - description can be null or non-empty

FaunalModel({
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

  // Converts a Supabase row into a faunal data
  factory FaunalModel.fromMap(Map<String, dynamic> map) {

    final rawDescription = map['description'] as String?;

    return FaunalModel(
      id: map['id'] as int, 
      site: map['site'] as String, 
      unit: map['unit'] as String, 
      yearOfAnalysis: map['year_of_analysis'] as int, 
      bone: map['bone'] as String,
      description: (rawDescription == null || rawDescription.trim().isEmpty) ? null : rawDescription,
    );
  }
}



