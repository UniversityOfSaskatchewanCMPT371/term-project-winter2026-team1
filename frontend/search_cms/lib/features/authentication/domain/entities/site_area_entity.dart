/*
  Domain representation of a Site-Area association in the archaeological system.

  Site_Area links sites to areas
  Identified by a key of:
  - siteId: UUID string referencing a Site
  - areaId: UUID string referencing an Area

  Invariants:
  - siteId must be a non-empty UUID string
  - areaId must be a non-empty UUID string
*/

class SiteAreaEntity {
  final String siteId;
  final String areaId;

  SiteAreaEntity({
    required this.siteId,
    required this.areaId,
  })
  // the assertions run before the constructor body when created
  // throws AssertionError on fail
  : assert(siteId.isNotEmpty),
    assert(areaId.isNotEmpty);
}