/*
  The PowerSync API interface for retrieving all units
 */
import 'package:search_cms/features/dashboard/data/models/unit_model.dart';

abstract class AbstractGetAllUnitsApi {
  /*
    Retrieves all Unit records from the database

    @return A list containing all UnitModel objects currently stored,
      if no units exist an empty list is returned

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  Future<List<UnitModel>> getAllUnits();
}