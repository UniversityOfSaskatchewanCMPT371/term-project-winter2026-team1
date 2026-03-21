/*
  Domain representation of an Assemblage in the archaeological system.

  An Assemblage is found in a Level and is identified by:
  - id: UUID string
  - levelId: UUID string of the level it belongs to
  - name: Assemblage name (can be empty)
  - createdAt: Timestamp of creation
  - updatedAt: Timestamp of last modification

  Invariants:
  - id must be a non-empty UUID string (id != "")
  - levelId must be a non-empty UUID string (levelId != "")
  - name can be non-empty or empty (name == null || name != null)
*/

class AssemblageEntity {
  final String id;
  final String levelId;
  final String name; // Empty or non-empty
  final DateTime createdAt;
  final DateTime updatedAt;

  AssemblageEntity({
    required this.id,
    required this.levelId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  })
  // The assertions run before the constructor body when created
  // Throws AssertionError on fail
  : assert(id.isNotEmpty),
    assert(levelId.isNotEmpty);
}




