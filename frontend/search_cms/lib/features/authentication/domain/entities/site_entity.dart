/*
  Domain representation of a Site in the archaeological system.

  A Site represents the top-level in the system and is identified by:
  - id: UUID string
  - name: Site name
  - borden: Unique archaeological code
  - createdAt: Timestamp of creation
  - updatedAt: Timestamp of last modification

  Invariants:
  - id must be a non-empty UUID string
  - name must be non-empty
  - borden must be non-empty and <= 8 characters
*/

class SiteEntity {
  final String id;
  final String name;
  final String borden;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SiteEntity({
    required this.id,
    required this.name,
    required this.borden,
    required this.createdAt,
    required this.updatedAt,
  }) 
  : assert(id.length > 0),
    assert(name.length > 0),
    assert(borden.length > 0),
    assert(borden.length < 8);
}
