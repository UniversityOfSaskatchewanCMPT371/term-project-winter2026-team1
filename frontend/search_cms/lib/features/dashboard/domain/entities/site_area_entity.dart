/*
  Domain representation of a Site-Area association in the archaeological system.

  Site_Area links sites to areas
  Identified by a key of:
  - id: UUID string
  - siteId: UUID string referencing a Site
  - areaId: UUID string referencing an Area

  Invariants:
  - id must be a non-empty UUID string
  - siteId must be a non-empty UUID string
  - areaId must be a non-empty UUID string
*/

class SiteAreaEntity {
  final String id;
  final String siteId;
  final String areaId;

  SiteAreaEntity({
    required this.id,
    required this.siteId,
    required this.areaId,
  })
  // The assertions run before the constructor body when created
  // Throws AssertionError on fail
  : assert (id.isNotEmpty),
    assert(siteId.isNotEmpty),
    assert(areaId.isNotEmpty);
}