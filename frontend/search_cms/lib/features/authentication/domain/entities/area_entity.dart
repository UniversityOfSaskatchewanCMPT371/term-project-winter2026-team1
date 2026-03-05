/*
  Domain representation of an Area in the archaeological system.

  An Area represents a specific zone associated with one or more Sites.
  Identified by:
  - id: UUID string
  - name: Area name (non-empty)
  - createdAt: Timestamp of creation
  - updatedAt: Timestamp of last modification

  Invariants:
  - id must be a non-empty UUID string
  - name must be non-empty
*/

class AreaEntity {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  AreaEntity({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  })
  : assert(id.isNotEmpty),
    assert(name.trim().isNotEmpty);
}