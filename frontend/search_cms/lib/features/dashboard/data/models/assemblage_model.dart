import 'package:powersync/sqlite3_common.dart' as sqlite;
import 'package:search_cms/features/dashboard/domain/entities/assemblage_entity.dart';

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

class AssemblageModel {
  final String id;
  final String levelId;
  final String? name; // Name can be empty or non-empty
  final DateTime createdAt;
  final DateTime updatedAt;

  AssemblageModel({
    required this.id,
    required this.levelId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  // Map AssemblageEntity instead of inheriting it to prevent coupling and proper separation
  AssemblageEntity toEntity() {
    return AssemblageEntity(
      id: id, 
      levelId: levelId, 
      name: name ?? '', 
      createdAt: createdAt, 
      updatedAt: updatedAt
    );
  }

  /*
    Creates an AssemblageModel from a PowerSync SQLite row.

    Preconditions:
    -  Row must contain: 'id', 'level_id', 'name', 'created_at', 'updated_at'

    Postconditions:
    - Returns an AssemblageModel
    - Ensures invariants are satisfied before creating the model

    Throws a FormatException if required columns are missing.
  */

  factory AssemblageModel.fromRow(sqlite.Row row) {

    // Extract raw dynamic values from PowerSync row
    final dynamic idRaw = row['id'];
    final dynamic levelIdRaw = row['level_id'];
    final dynamic nameRaw = row['name'];
    final dynamic createdRaw = row['created_at'];
    final dynamic updatedRaw = row['updated_at'];

    // Check if anything is null. If so, throw an exception
    if (
      idRaw == null ||
      levelIdRaw == null ||
      createdRaw == null ||
      updatedRaw == null) {
      throw FormatException('Missing required column(s) for AssemblageModel');
    }

      // Convert raw values from PowerSync rows
      final String id = idRaw.toString();
      final String levelId = levelIdRaw.toString();

      final String? name;

      // If name is not empty, then trim it; otherwise, make it null
      if(nameRaw != null) {
        name = nameRaw.toString().trim();
      } else {
        name = null;
      }

    final DateTime createdAt = DateTime.parse(createdRaw.toString());
    final DateTime updatedAt = DateTime.parse(updatedRaw.toString());

    assert(id.isNotEmpty, 'Assemblage ID cannot be empty');
    assert(levelId.isNotEmpty, 'Level ID cannot be empty');

    return AssemblageModel(
      id: id, 
      levelId: levelId, 
      name: name, 
      createdAt: createdAt, 
      updatedAt: updatedAt,
    );
  }
}


