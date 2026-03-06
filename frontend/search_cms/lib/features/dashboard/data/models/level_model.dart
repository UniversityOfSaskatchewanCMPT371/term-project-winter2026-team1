import 'package:powersync/sqlite3_common.dart' as sqlite;
import 'package:search_cms/features/dashboard/domain/entities/level_entity.dart';

/*
  Data-layer model responsible for mapping PowerSync SQLite row.
*/

class LevelModel {
  final String id;
  final String unitId;
  final String? parentId;
  final String name;
  final int upLimit;
  final int lowLimit;
  final String? levelChar;
  final int? levelInt;
  final DateTime createdAt;
  final DateTime updatedAt;

  LevelModel({
    required this.id,
    required this.unitId,
    this.parentId,
    required this.name,
    required this.upLimit,
    required this.lowLimit,
    this.levelChar,
    this.levelInt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Map LevelEntity instead of inheriting it to prevent coupling and proper separation
  LevelEntity toEntity() {
    return LevelEntity(
      id: id,
      unitId: unitId,
      parentId: parentId,
      name: name,
      upLimit: upLimit,
      lowLimit: lowLimit,
      levelChar: levelChar,
      levelInt: levelInt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /*
    Creates a LevelModel from a PowerSync SQLite row.

    Preconditions:
    - Row must contain: 'id', 'unit_id', 'name', 'up_limit', 'low_limit', 'created_at', 'updated_at'
    - 'parent_id', 'level_char', 'level_int' are optional

    Postconditions:
    - Returns a LevelModel
    - Ensures invariants are satisfied before creating the model

    Throws a FormatException if required columns are missing.
  */

  factory LevelModel.fromRow(sqlite.Row row) {

    // Extract raw dynamic values from PowerSync row
    final dynamic idRaw = row['id'];
    final dynamic unitIdRaw = row['unit_id'];
    final dynamic parentIdRaw = row['parent_id'];
    final dynamic nameRaw = row['name'];
    final dynamic upLimitRaw = row['up_limit'];
    final dynamic lowLimitRaw = row['low_limit'];
    final dynamic createdRaw = row['created_at'];
    final dynamic updatedRaw = row['updated_at'];
    final dynamic levelCharRaw = row['level_char'];
    final dynamic levelIntRaw = row['level_int'];


    // Check if anything is null. If so, throw an exception
    if (idRaw == null ||
        unitIdRaw == null ||
        nameRaw == null ||
        createdRaw == null ||
        updatedRaw == null) {
      throw FormatException('Missing required column(s)');
    }

    // Convert raw values from PowerSync rows
    final String id = idRaw.toString();
    final String unitId = unitIdRaw.toString();
    final String? parentId = parentIdRaw?.toString();
    final String name = nameRaw.toString().trim();
    final DateTime createdAt = DateTime.parse(createdRaw.toString());
    final DateTime updatedAt = DateTime.parse(updatedRaw.toString());
    final String? levelChar = levelCharRaw?.toString();

    // Needs to be a seperate check since its optional, need to manually set to null if not used
    final int? levelInt;
    if (levelIntRaw != null) {
      levelInt = int.parse(levelIntRaw.toString());
    } else {
      levelInt = null;
    }
    // default upLimit and lowLimit to 0 if null in the db from what the schema says
    final int upLimit;
    if (upLimitRaw != null) {
      upLimit = int.parse(upLimitRaw.toString());
    } else {
      upLimit = 0;
    }

    final int lowLimit;
    if (lowLimitRaw != null) {
      lowLimit = int.parse(lowLimitRaw.toString());
    } else {
      lowLimit = 0;
    }

    assert(id.isNotEmpty, 'ID cannot be empty');
    assert(unitId.isNotEmpty, 'Unit ID cannot be empty');
    assert(name.isNotEmpty, 'Name cannot be empty');
    assert(upLimit <= lowLimit, 'Up limit must be lower than low limit');

    return LevelModel(
      id: id,
      unitId: unitId,
      parentId: parentId,
      name: name,
      upLimit: upLimit,
      lowLimit: lowLimit,
      levelChar: levelChar,
      levelInt: levelInt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}