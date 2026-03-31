/*
  The abstract API interface for inserting a site_area relationship
*/
abstract class AbstractInsertSiteAreaApi {
  /*
    Inserts a new site_area record into the database

    @param siteId A valid UUID reference to an existing site
    @param areaId A valid UUID reference to an existing area

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) siteId.isNotEmpty && areaId.isNotEmpty

    Postconditions: new site_area record is inserted into the database
  */
  Future<void> insertSiteArea({required String siteId, required String areaId});
}
