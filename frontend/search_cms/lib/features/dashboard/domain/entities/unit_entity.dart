/*
  Domain representation of a Unit in the archaeological system.

  A Unit belongs to a Site 
  identified by:
  - id: UUID string
  - siteId: UUID string of site it belongs to
  - name: Site name 
  - createdAt: Timestamp of creation
  - updatedAt: Timestamp of last modification

  Invariants:
  - id must be a non-empty UUID string
  - siteId must be a non-empty UUID string
  - name can be non-empty 
*/

class UnitEntity {
  final String id;
  final String siteId;
  final String name; 
  final DateTime createdAt;
  final DateTime updatedAt;

  UnitEntity({
    required this.id,
    required this.siteId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  }) 
  // The assertions run before the constructor body when created
  // Throws AssertionError on fail
  : assert(id.isNotEmpty),
    assert(siteId.isNotEmpty),
    assert(name.isNotEmpty);
}