/*
  Domain representation of a Level in the archaeological system.

  A Level belongs to a Unit
  identified by:
  - id: UUID string
  - unitId: UUID string of the unit it belongs to
  - parentId: UUID string of the parent level, null if top-most (should not have parent)
  - name: Level name
  - upLimit: Upper depth limit
  - lowLimit: Lower depth limit
  - levelChar: Single character label (schema says optional but include for now)
  - levelInt: Integer label (schema says optional but include for now)
  - createdAt: Timestamp of creation
  - updatedAt: Timestamp of last modification

  Invariants:
  - id must be a non-empty string
  - unitId must be a non-empty string
  - name must be a non-empty string
  - upLimit <= lowLimit
  - levelChar must be a single character if provided
*/

class LevelEntity {
  final String id;
  final String unitId;
  final String? parentId; // Empty or non-empty
  final String name;
  final int upLimit;
  final int lowLimit;
  final String? levelChar; // Empty or non-empty
  final int? levelInt; // Empty or non-empty
  final DateTime createdAt;
  final DateTime updatedAt;

  LevelEntity({
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
  })
  : assert(id.isNotEmpty),
    assert(unitId.isNotEmpty),
    assert(name.isNotEmpty),
    assert(upLimit <= lowLimit),
    assert(levelChar == null || levelChar.length <= 1);
}