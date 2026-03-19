import '../../../../core/utils/class_templates/result.dart';

/*
  The repository interface for retrieving all levels
 */
abstract class AbstractGetAllLevelsRepository {

  /*
    Retrieves all Levels in the system

    @return A list containing all LevelEntity objects currently stored,
      if no levels exist an empty list is returned

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  Future<Result> getAllLevels();
}