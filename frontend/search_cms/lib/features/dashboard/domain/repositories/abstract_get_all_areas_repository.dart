import 'package:search_cms/core/utils/class_templates/result.dart';

/*
  The repository contract for retrieving all areas
 */
abstract class AbstractGetAllAreasRepository {
  /*
    Retrieves all Areas in the system

    @return A Success if the fetch is successful, containing the list of area
      entities or Failure containing the errorMessage otherwise

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  Future<Result> getAllAreas();
}