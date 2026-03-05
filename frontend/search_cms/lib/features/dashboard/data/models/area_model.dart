import 'package:powersync/sqlite3_common.dart' as sqlite;
import 'package:search_cms/features/authentication/domain/entities/area_entity.dart';

/*
  Data-layer model responsible for mapping PowerSync SQLite row. 
*/
class AreaModel {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  AreaModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  /* 
  / Converts the model into an AreaEntity
  / Replaces the need to inherit from AreaEntity becuase we don't want
  / The domain layer (AreaEntity) and the data layer (AreaModel) to be coupled
  */
  AreaEntity toEntity() {
    return AreaEntity(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
  /*
    Creates a AreaModel from a PowerSync SQLite row.

    Preconditions:
    -  Row must contain: 'id', 'name', 'created_at', 'updated_at'

    Postconditions:
    - Returns a AreaModel
    - Ensures invariants are satisfied before creating the model

    Throws a FormatException if required columns are missing.
  */

  factory AreaModel.fromRow(sqlite.Row row) {
    // Extract raw dynamic values from Powersync rows
    final dynamic idRaw = row['id'];
    final dynamic nameRaw = row['name'];
    final dynamic createdRaw = row['created_at'];
    final dynamic updatedRaw = row['updated_at'];

    // Check if anything is null if so, throw exception
    if (idRaw == null ||
      nameRaw == null ||
      createdRaw == null ||
      updatedRaw == null) {
        throw FormatException('Missing required column');
      }
    
    // Convert raw values from PowerSync rows
    final String id = idRaw.toString();
    final String name = nameRaw.toString().trim();
    final DateTime createdAt = DateTime.parse(createdRaw.toString());
    final DateTime updatedAt = DateTime.parse(updatedRaw.toString());

    // Assertions for double check
    assert(id.isNotEmpty, 'Area ID cannot be empty');
    assert(name.isNotEmpty, 'Area name cannot be empty');

    // Create and return AreaModel
    return AreaModel(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}