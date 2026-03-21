import 'package:search_cms/core/utils/class_templates/result.dart';

/*
  The repository interface for retrieving all units
 */
abstract class AbstractGetAllUnitsRepository {
  /*
    Retrieves all Units in the system

    @return A Success if the fetch is successful, containing the list of unit
      entities or Failure containing the errorMessage otherwise

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  Future<Result> getAllUnits();
}