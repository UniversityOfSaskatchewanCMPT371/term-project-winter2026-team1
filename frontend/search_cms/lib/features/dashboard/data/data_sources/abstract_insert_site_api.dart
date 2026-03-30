/*
  The abstract API interface for inserting a site
*/
abstract class AbstractInsertSiteApi {
  /*
    Inserts a new Site record into the database

    @param borden A non-empty borden string with a maximum length of 8 characters
    @param name An optional name for the site

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) borden.isNotEmpty && borden.length <= 8

    Postconditions: new site record is inserted into the database
  */
  Future<void> insertSite({required String borden, String? name});
}
