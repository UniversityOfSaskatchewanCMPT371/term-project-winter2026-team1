import 'package:search_cms/core/utils/class_templates/result.dart';

/*
  The repository interface for retrieving all units
 */
abstract class AbstractGetAllUnitsRepository {
  /*
    Retrieves all Units in the system

    @return A list containing all UnitEntity objects currently stored
      if no units exist an empty list is returned

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  Future<Result> getAllUnits();
}