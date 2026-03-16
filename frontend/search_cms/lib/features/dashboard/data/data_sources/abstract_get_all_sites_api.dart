import 'package:search_cms/features/dashboard/data/models/site_model.dart';

/*
  The PowerSync API interface for retrieving all sites
 */
abstract class AbstractGetAllSitesApi {
  /*
    Retrieves all Site records from the database

    @return A list containing all SiteModel objects currently stored
      if no sites exist an empty list is returned

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  Future<List<SiteModel>> getAllSites();
}