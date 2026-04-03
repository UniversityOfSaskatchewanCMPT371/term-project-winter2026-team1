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
  - Convert dynamic raw values into Dart data types (String, int, Datetime, etc.)
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
  final int? upLimit;
  final int? lowLimit;

  // Assemblage
  final String? assemblageName;

  // Artifact_Faunal
  final int? porosity;
  final double? sizeUpper;
  final double? sizeLower;
  final String? comment;
  final int? preExcavFrags;
  final int? postExcavFrags;
  final int? elements;

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
      upLimit: upLimit ?? 0, 
      lowLimit: lowLimit ?? 0, 
      assemblageName: assemblageName ?? '',
      porosity: porosity,
      sizeUpper: sizeUpper,
      sizeLower: sizeLower, 
      comment: comment ?? '', 
      preExcavFrags: preExcavFrags ?? 0, 
      postExcavFrags: postExcavFrags ?? 0, 
      elements: elements ?? 0
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

    // Convert raw values from PowerSync rows
    final String? borden = bordenRaw?.toString().trim();
    final String? areaName = areaNameRaw?.toString().trim();
    final String? unitName = unitNameRaw?.toString().trim();
    final String? levelName = levelNameRaw?.toString().trim();
    // if upLimitRaw is not null, try to parse the string representation to an int, otherwise upLimit = null
    final int? upLimit = upLimitRaw != null ? int.tryParse(upLimitRaw.toString()) : null;
    final int? lowLimit = lowLimitRaw != null ? int.tryParse(lowLimitRaw.toString()) : null;
    final int? preExcavFrags = preExcavFragsRaw != null ? int.tryParse(preExcavFragsRaw.toString()) : null;
    final int? postExcavFrags = postExcavFragsRaw != null ? int.tryParse(postExcavFragsRaw.toString()) : null;
    final int? elements = elementsRaw != null ? int.tryParse(elementsRaw.toString()) : null;

    // If site name is not null, then trim it; otherwise, make it null
    final String? siteName;
    if(siteNameRaw != null) {
      siteName = siteNameRaw.toString().trim();
    } else {
      siteName = null;
    }

    // If assemblage name is not null, then trim it; otherwise, make it null
    final String? assemblageName;
    if(assemblageNameRaw != null) {
      assemblageName = assemblageNameRaw.toString().trim();
    } else {
      assemblageName = null;
    }

    // As per the schema, porosity can be null or must be between 1-5
    final int? porosity;
    if (porosityRaw != null) {
      porosity = int.parse(porosityRaw.toString());
    } else {
      porosity = null;
    }

    // As per the schema, size upper can be null or have a value
    final double? sizeUpper;
    if (sizeUpperRaw != null) {
      sizeUpper = double.parse(sizeUpperRaw.toString());
    } else {
      sizeUpper = null;
    }

    // As per the schema, size lower can be null or have a value
    final double? sizeLower;
    if (sizeLowerRaw != null) {
      sizeLower = double.parse(sizeLowerRaw.toString());
    } else {
      sizeLower = null;
    }
    
    // If comment is not null, then trim it; otherwise, make it null
    final String? comment;
    if (commentRaw != null) {
      comment = commentRaw.toString().trim();
    } else {
      comment = null;
    }

    if (upLimit != null && lowLimit != null) {
      assert(upLimit <= lowLimit, 'Up limit must be lower than low limit');
    }
    assert(porosity == null || (porosity > 0 && porosity <= 5),
    'Porosity must be between 1-5');
    assert(sizeUpper == null || sizeLower == null || sizeUpper >= sizeLower,
    'Size upper must be greater than size lower');
    if (preExcavFrags != null) {
      assert(preExcavFrags > 0, 'There must be at least 1 pre excav frag');
    }
    if (postExcavFrags != null) {
      assert(postExcavFrags > 0, 'There must be at least 1 post excav frag');
    }
    if (elements != null) {
      assert(elements > 0, 'There must be at least 1 element');
    }

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


