/*
  The site entity for the domain layer.

  @param id The uuid for the site
  @param name The name of the site. Can be empty.
  @param borden The Borden classification code for the site. Max 8 characters.
 */
class SiteEntity {
  final String id;
  final String name;
  final String borden;

  SiteEntity({
    required this.id,
    required this.name,
    required this.borden,
  });
}
