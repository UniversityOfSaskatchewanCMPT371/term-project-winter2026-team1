import '../../../../core/utils/class_templates/result.dart';

/*
  The repository interface for retrieving all levels
 */
abstract class AbstractGetAllLevelsRepository {

  /*
    Retrieves all Levels in the system

    @return A Success if the fetch is successful, containing the list of level
      entities or Failure containing the errorMessage otherwise

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  Future<Result> getAllLevels();
}