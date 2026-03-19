import '../models/level_model.dart';
/*
  The PowerSync API interface for retrieving all levels
 */
abstract class AbstractGetAllLevelsApi {
  /*
    Retrieves all Level records from the database

    @return A list containing all LevelModel objects currently stored,
      if no levels exist an empty list is returned

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  Future<List<LevelModel>> getAllLevels();
}