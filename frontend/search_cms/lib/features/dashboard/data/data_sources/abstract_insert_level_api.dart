/*
  The abstract API interface for inserting a level
*/
abstract class AbstractInsertLevelApi {
  /*
    Inserts a new Level record into the database

    @param unitId A valid UUID reference to an existing unit
    @param name A non-empty name string for the level
    @param upLimit An integer representing the upper depth limit in cm
    @param lowLimit An integer representing the lower depth limit in cm
    @param parentId An optional reference to an existing level which is the level's parent
    @param levelChar An optional string representing some other archeological data
    @param levelInt An optional integer representing some other archeological data

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) unitId.isNotEmpty && name.isNotEmpty && upLimit <= lowLimit

    Postconditions: new level record is inserted into the database
  */
  Future<void> insertLevel({
    required String unitId,
    required String name,
    required int upLimit,
    required int lowLimit,
    String? parentId,
    String? levelChar,
    int? levelInt,
  });
}
