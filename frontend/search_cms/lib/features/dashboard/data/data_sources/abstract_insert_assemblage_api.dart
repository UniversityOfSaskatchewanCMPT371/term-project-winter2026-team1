/*
  The abstract API interface for inserting an assemblage
*/
abstract class AbstractInsertAssemblageApi {
  /*
    Inserts a new Assemblage record into the database

    @param name? optional name
    @param unitName name of the associated Unit
    @param levelName name of associated Level

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) unitName.isNotEmpty && levelName.isNotEmpty

    Postconditions: new assemblage record is inserted into the database
  */
  Future<void> insertAssemblage({String? name, required String unitName, required String levelName});
}
