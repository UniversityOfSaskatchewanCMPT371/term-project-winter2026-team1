import 'package:powersync/sqlite3_common.dart' as sqlite;
import 'package:search_cms/features/dashboard/domain/entities/unit_entity.dart';

/*
  Data-layer model responsible for mapping PowerSync SQLite row. 
*/

class UnitModel {
  final String id;
  final String siteId; 
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  UnitModel({
    required this.id,
    required this.siteId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  // Map UnitEntity instead of inheriting it to prevent coupling and proper seperation
  UnitEntity toEntity() {
    return UnitEntity(
      id: id, 
      siteId: siteId,
      name: name, 
      createdAt: createdAt, 
      updatedAt: updatedAt
      );
  }

  /*
    Creates a UnitModel from a PowerSync SQLite row.

    Preconditions:
    -  Row must contain: 'id', 'name', 'siteId', 'created_at', 'updated_at'

    Postconditions:
    - Returns a UnitModel
    - Ensures invariants are satisfied before creating the model

    Throws a FormatException if required columns are missing.
  */

  factory UnitModel.fromRow(sqlite.Row row) {

    // Extract raw dynamic values from PowerSync row
    final dynamic idRaw = row['id'];
    final dynamic siteIdRaw = row['site_id'];
    final dynamic nameRaw = row['name'];
    final dynamic createdRaw = row['created_at'];
    final dynamic updatedRaw = row['updated_at'];

    // Check if anything is null. If so, throw an exception
    if (
      idRaw == null ||
      siteIdRaw == null ||
      nameRaw == null ||
      createdRaw == null ||
      updatedRaw == null) {
      throw FormatException('Missing required column(s)');
    }

    // Convert raw values from PowerSync rows
    final String id = idRaw.toString();
    final String siteId = siteIdRaw.toString();

    final String name = nameRaw.toString().trim();

    final DateTime createdAt = DateTime.parse(createdRaw.toString());
    final DateTime updatedAt = DateTime.parse(updatedRaw.toString());

    assert(id.isNotEmpty, 'ID cannot be empty');
    assert(siteId.isNotEmpty, 'Site ID cannot be empty');
    assert(name.isNotEmpty, 'name cannot be empty');

    return UnitModel(
      id: id, 
      siteId: siteId,
      name: name, 
      createdAt: createdAt, 
      updatedAt: updatedAt
    );
  }
}
