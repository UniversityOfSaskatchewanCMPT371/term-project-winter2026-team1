/*
  The site model for the site data.

  @param id The uuid for the site
  @param name The name of the site. Can be empty.
  @param borden The Borden classification code for the site. Max 8 characters.
 */
class SiteModel {
  final String id;
  final String name;
  final String borden;

  SiteModel({
    required this.id,
    required this.name,
    required this.borden,
  });
}
