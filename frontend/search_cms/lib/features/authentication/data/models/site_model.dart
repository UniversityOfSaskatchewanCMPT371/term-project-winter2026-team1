import 'package:powersync/sqlite3_common.dart' as sqlite;
import 'package:search_cms/features/authentication/domain/entities/site_entity.dart';

/*
  Data-layer model responsible for mapping PowerSync SQLite row. 
*/

class SiteModel {
  final String id;
  final String name;
  final String borden;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SiteModel({
    required this.id,
    required this.name,
    required this.borden,
    required this.createdAt,
    required this.updatedAt,
  });

  // Map SiteEntity instead of inheriting it to prevent coupling and proper seperation
  SiteEntity toEntity() {
    return SiteEntity(id: id, name: name, borden: borden, createdAt: createdAt, updatedAt: updatedAt);
  }

  /*
    Creates a SiteModel from a PowerSync SQLite row.

    Preconditions:
    -  Row must contain: 'id', 'name', 'borden', 'created_at', 'updated_at'

    Postconditions:
    - Returns a SiteModel
    - Ensures invariants are satisfied before creating the model

    Throws a FormatException if required columns are missing.
  */

  factory SiteModel.fromRow(sqlite.Row row) {

    // Dynamically read rows from PowerSync first (skip type checking)
    final dynamic idRaw = row['id'];
    final dynamic nameRaw = row['name'];
    final dynamic bordenRaw = row['borden'];
    final dynamic createdRaw = row['created_at'];
    final dynamic updatedRaw = row['updated_at'];

    // Check if anything is null. If so, throw an exception
    if (
      idRaw == null ||
      nameRaw == null ||
      bordenRaw == null ||
      createdRaw == null ||
      updatedRaw == null) {
      throw FormatException('Missing required column(s)');
    }

    // Convert raw data from PowerSync rows
    final String id = idRaw.toString();
    final String name = nameRaw.toString().trim();
    final String borden = bordenRaw.toString().trim();

    final DateTime createdAt = DateTime.parse(createdRaw.toString());
    final DateTime updatedAt = DateTime.parse(updatedRaw.toString());

    assert(id.isNotEmpty, 'Site ID cannot be empty');
    assert(name.isNotEmpty, 'Site name cannot be empty');
    assert(borden.isNotEmpty, 'Borden code cannot be empty');
    assert(borden.length <= 8, 'Borden code should not be more than 8 characters');

    return SiteModel(
      id: id, 
      name: name, 
      borden: borden, 
      createdAt: createdAt, 
      updatedAt: updatedAt
    );
  }
}



