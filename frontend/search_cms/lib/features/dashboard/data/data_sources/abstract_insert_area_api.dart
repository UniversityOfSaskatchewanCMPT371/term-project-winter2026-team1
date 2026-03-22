/*
  The abstract API interface for inserting an area
*/
abstract class AbstractInsertAreaApi {
  /*
    Inserts a new Area record into the database

    @param name A non-empty name string for the area

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) name.isNotEmpty

    Postconditions: new area record is inserted into the database
  */
  Future<void> insertArea({required String name});
}
