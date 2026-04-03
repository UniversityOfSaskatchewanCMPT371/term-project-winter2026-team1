import 'package:powersync/sqlite3_common.dart' as sqlite;
import 'package:search_cms/features/dashboard/domain/entities/table_row_entity.dart';

/*
  Data-layer model responsible for mapping PowerSync SQLite row.

  This model acts as the bridge between the database layer and the domain layer.
  It is responsible for converting database rows in Dart objects.
  
  This model helps maintain separation of concerns by separating database logic from the domain layer, 
  ensuring that domain entities remain independent.

  Responsibilities:
  - Provide a mapping function (toEntity()) to convert the model into an entity
  - Extract raw values from a PowerSync SQLite row
  - Convert dynamic raw values into trimmed strings
  - Handle nullable fields and optional values
  - Check that all the required fields are present before creating a model (object)
*/

class TableRowModel {

  // Site
  final String? borden;
  final String? siteName;

  // Area
  final String? areaName;

  // Unit
  final String? unitName;

  // Level
  final String? levelName;
  final String? upLimit;
  final String? lowLimit;

  // Assemblage
  final String? assemblageName;

  // Artifact_Faunal
  final String? porosity;
  final String? sizeUpper;
  final String? sizeLower;
  final String? comment;
  final String? preExcavFrags;
  final String? postExcavFrags;
  final String? elements;

  TableRowModel({
    this.borden,
    this.siteName,
    this.areaName,
    this.unitName,
    this.levelName,
    this.upLimit,
    this.lowLimit,
    this.assemblageName,
    this.porosity,
    this.sizeUpper,
    this.sizeLower,
    this.comment,
    this.preExcavFrags,
    this.postExcavFrags,
    this.elements,
  });

  // Map TableRowEntity instead of inheriting it to prevent coupling and proper separation
  TableRowEntity toEntity() {
    return TableRowEntity(
      borden: borden ?? '', 
      siteName: siteName ?? '', 
      areaName: areaName ?? '', 
      unitName: unitName ?? '', 
      levelName: levelName ?? '', 
      upLimit: upLimit ?? '',
      lowLimit: lowLimit ?? '',
      assemblageName: assemblageName ?? '',
      porosity: porosity,
      sizeUpper: sizeUpper,
      sizeLower: sizeLower,
      comment: comment ?? '',
      preExcavFrags: preExcavFrags ?? '',
      postExcavFrags: postExcavFrags ?? '',
      elements: elements ?? ''
    );
  }

  /*
    Creates an TableRowModel from a PowerSync SQLite row.

    Preconditions:
    - Row cannot be completely empty

    Postconditions:
    - Returns an TableRow Model
    - Ensures invariants are satisfied before creating the model

    Throws a FormatException if row is empty.
  */

  factory TableRowModel.fromRow(sqlite.Row row) {

    // Extract raw dynamic values from PowerSync row
    final dynamic bordenRaw = row['borden'];
    final dynamic siteNameRaw = row['site_name'];
    final dynamic areaNameRaw = row['area_name'];
    final dynamic unitNameRaw = row['unit_name'];
    final dynamic levelNameRaw = row['level_name'];
    final dynamic upLimitRaw = row['up_limit'];
    final dynamic lowLimitRaw = row['low_limit'];
    final dynamic assemblageNameRaw = row['assemblage_name'];
    final dynamic porosityRaw = row['porosity'];
    final dynamic sizeUpperRaw = row['size_upper'];
    final dynamic sizeLowerRaw = row['size_lower'];
    final dynamic commentRaw = row['comment'];
    final dynamic preExcavFragsRaw = row['pre_excav_frags'];
    final dynamic postExcavFragsRaw = row['post_excav_frags'];
    final dynamic elementsRaw = row['elements'];

    // Check if everthing is null. If so, throw an exception
    if (
      bordenRaw == null &&
      siteNameRaw == null &&
      areaNameRaw == null &&
      unitNameRaw == null &&
      levelNameRaw == null &&
      upLimitRaw == null &&
      lowLimitRaw == null &&
      assemblageNameRaw == null &&
      porosityRaw == null &&
      sizeUpperRaw == null &&
      sizeLowerRaw == null &&
      commentRaw == null &&
      preExcavFragsRaw == null &&
      postExcavFragsRaw == null &&
      elementsRaw == null) {
      throw FormatException('Row Empty in TableRowModel');
    }

    // Convert raw values from PowerSync rows into trimmed strings (or null if absent)
    final String? borden = bordenRaw?.toString().trim();
    final String? siteName = siteNameRaw?.toString().trim();
    final String? areaName = areaNameRaw?.toString().trim();
    final String? unitName = unitNameRaw?.toString().trim();
    final String? levelName = levelNameRaw?.toString().trim();
    final String? upLimit = upLimitRaw?.toString().trim();
    final String? lowLimit = lowLimitRaw?.toString().trim();
    final String? assemblageName = assemblageNameRaw?.toString().trim();
    final String? porosity = porosityRaw?.toString().trim();
    final String? sizeUpper = sizeUpperRaw?.toString().trim();
    final String? sizeLower = sizeLowerRaw?.toString().trim();
    final String? comment = commentRaw?.toString().trim();
    final String? preExcavFrags = preExcavFragsRaw?.toString().trim();
    final String? postExcavFrags = postExcavFragsRaw?.toString().trim();
    final String? elements = elementsRaw?.toString().trim();

    // Validate numeric invariants by parsing the string values
    assert(
      // if upLimit and lowLimit exist, ensure upLimit <= lowLimit
      upLimit == null || lowLimit == null ||
      int.tryParse(upLimit) == null || int.tryParse(lowLimit) == null ||
      int.parse(upLimit) <= int.parse(lowLimit),
      'Up limit must be lower than low limit'
    );
    assert(
      // if porosity exists, assert 1 <= porosity <= 5
      porosity == null ||
      (int.tryParse(porosity) != null && int.parse(porosity) > 0 && int.parse(porosity) <= 5),
      'Porosity must be between 1-5'
    );
    assert(
      // if sizeUpper and sizeLower exist, assert sizeUpper >= sizeLower
      sizeUpper == null || sizeLower == null ||
      double.tryParse(sizeUpper) == null || double.tryParse(sizeLower) == null ||
      double.parse(sizeUpper) >= double.parse(sizeLower),
      'Size upper must be greater than size lower'
    );
    assert(
      // allows empty strings but will reject non-numeric, zeros and negatives
      preExcavFrags == null || (int.tryParse(preExcavFrags) ?? -1) > 0,
      'There must be at least 1 pre excav frag'
    );
    assert(
      // allows empty strings but will reject non-numeric, zeros and negatives
      postExcavFrags == null || (int.tryParse(postExcavFrags) ?? -1) > 0,
      'There must be at least 1 post excav frag'
    );
    assert(
      // allows empty strings but will reject non-numeric, zeros and negatives
      elements == null || (int.tryParse(elements) ?? -1) > 0,
      'There must be at least 1 element'
    );

    return TableRowModel(
      borden: borden, 
      siteName: siteName, 
      areaName: areaName, 
      unitName: unitName, 
      levelName: levelName, 
      upLimit: upLimit, 
      lowLimit: lowLimit, 
      assemblageName: assemblageName,
      porosity: porosity,
      sizeUpper: sizeUpper,
      sizeLower: sizeLower, 
      comment: comment, 
      preExcavFrags: preExcavFrags, 
      postExcavFrags: postExcavFrags, 
      elements: elements
    );
  }
}


