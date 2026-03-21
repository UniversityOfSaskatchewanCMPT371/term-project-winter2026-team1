import 'package:powersync/sqlite3_common.dart' as sqlite;
import 'package:search_cms/features/dashboard/domain/entities/artifact_faunal_entity.dart';

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

class ArtifactFaunalModel {
  final String id;
  final String assemblageId;
  final int? porosity;
  final double? sizeUpper;
  final double? sizeLower;
  final String? comment;
  final int preExcavFrags;
  final int postExcavFrags;
  final int elements;
  final DateTime createdAt;
  final DateTime updatedAt;

  ArtifactFaunalModel({
    required this.id,
    required this.assemblageId,
    this.porosity,
    this.sizeUpper,
    this.sizeLower,
    required this.comment,
    required this.preExcavFrags,
    required this.postExcavFrags,
    required this.elements,
    required this.createdAt,
    required this.updatedAt,
  });

  // Map ArtifactFaunalEntity instead of inheriting it to prevent coupling and proper separation
  ArtifactFaunalEntity toEntity() {
    return ArtifactFaunalEntity(
      id: id, 
      assemblageId: assemblageId,
      porosity: porosity,
      sizeUpper: sizeUpper,
      sizeLower: sizeLower, 
      comment: comment ?? '', 
      preExcavFrags: preExcavFrags, 
      postExcavFrags: postExcavFrags, 
      elements: elements, 
      createdAt: createdAt, 
      updatedAt: updatedAt
    );
  }

  /*
    Creates an ArtifactFaunalModel from a PowerSync SQLite row.

    Preconditions:
    - Row must contain: 'id', 'assemblage_Id', 'comment', 
      'pre_excav_frags', 'post_excav_frags', 'elements', 'created_at', 'updated_at'
    - 'porosity', 'size_upper', 'size_lower' are optional

    Postconditions:
    - Returns an ArtifactFaunal Model
    - Ensures invariants are satisfied before creating the model

    Throws a FormatException if required columns are missing.
  */

  factory ArtifactFaunalModel.fromRow(sqlite.Row row) {

    // Extract raw dynamic values from PowerSync row
    final dynamic idRaw = row['id'];
    final dynamic assemblageIdRaw = row['assemblage_id'];
    final dynamic porosityRaw = row['porosity'];
    final dynamic sizeUpperRaw = row['size_upper'];
    final dynamic sizeLowerRaw = row['size_lower'];
    final dynamic commentRaw = row['comment'];
    final dynamic preExcavFragsRaw = row['pre_excav_frags'];
    final dynamic postExcavFragsRaw = row['post_excav_frags'];
    final dynamic elementsRaw = row['elements'];
    final dynamic createdRaw = row['created_at'];
    final dynamic updatedRaw = row['updated_at'];

    // Check if anything is null. If so, throw an exception
    if (
      idRaw == null ||
      assemblageIdRaw == null ||
      preExcavFragsRaw == null ||
      postExcavFragsRaw == null ||
      elementsRaw == null ||
      createdRaw == null ||
      updatedRaw == null) {
      throw FormatException('Missing required column(s) for ArtifactFaunalModel');
    }

    // Convert raw values from PowerSync rows
    final String id = idRaw.toString();
    final String assemblageId = assemblageIdRaw.toString();
    final int preExcavFrags = int.parse(preExcavFragsRaw.toString());
    final int postExcavFrags = int.parse(postExcavFragsRaw.toString());
    final int elements = int.parse(elementsRaw.toString());
    final DateTime createdAt = DateTime.parse(createdRaw.toString());
    final DateTime updatedAt = DateTime.parse(updatedRaw.toString());

    // Optional fields

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
    
    // If comment is not empty, then trim it; otherwise, make it null
    final String? comment;
    if (commentRaw != null) {
      comment = commentRaw.toString().trim();
    } else {
      comment = null;
    }
    
    assert(id.isNotEmpty, 'ID cannot be empty');
    assert(assemblageId.isNotEmpty, 'Assemblage ID cannot be empty');
    assert(porosity == null || (porosity > 0 && porosity <= 5), 
    'Porosity must be between 1-5');
    assert(sizeUpper == null || sizeLower == null || sizeUpper >= sizeLower, 
    'Size upper must be greater than size lower');
    assert(preExcavFrags > 0, 'There must be at least 1 pre excav frag');
    assert(postExcavFrags > 0, 'There must be at least 1 post excav frag');
    assert(elements > 0, 'There must be at least 1 element');

    return ArtifactFaunalModel(
      id: id, 
      assemblageId: assemblageId,
      porosity: porosity,
      sizeUpper: sizeUpper,
      sizeLower: sizeLower, 
      comment: comment, 
      preExcavFrags: preExcavFrags, 
      postExcavFrags: postExcavFrags, 
      elements: elements, 
      createdAt: createdAt, 
      updatedAt: updatedAt
    );
  }
}



