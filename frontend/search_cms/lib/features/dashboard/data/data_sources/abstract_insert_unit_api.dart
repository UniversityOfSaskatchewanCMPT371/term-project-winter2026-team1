/*
  The abstract API interface for inserting a unit
*/
abstract class AbstractInsertUnitApi {
  /*
    Inserts a new Unit record into the database

    @param siteId A valid UUID reference to an existing site
    @param name A non-empty name string for the unit

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) siteId.isNotEmpty && name.isNotEmpty

    Postconditions: new unit record is inserted into the database
  */
  Future<void> insertUnit({required String siteId, required String name});
}
