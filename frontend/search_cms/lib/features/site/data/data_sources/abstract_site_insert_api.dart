import '../models/site_model.dart';

abstract class AbstractSiteInsertApi {

  /*
    The api function for inserting a new site into Supabase

    @param name A String containing the name of the site. Can be empty.
    @param borden A String containing the Borden classification code.
      Max 8 characters and must be unique.
    @return A SiteModel instance if insert is successful or null otherwise

    Preconditions: borden.length <= 8 && borden.isNotEmpty
   */
  Future<SiteModel?> insertSite(String name, String borden);
}
