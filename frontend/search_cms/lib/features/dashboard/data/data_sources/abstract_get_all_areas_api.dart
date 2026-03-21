import 'package:search_cms/features/dashboard/data/models/area_model.dart';

/*
  The PowerSync API contract for retrieving all areas
 */
abstract class AbstractGetAllAreasApi {
  /*
    Retrieves all Area records from the database

    @return A list containing all AreaModel objects currently stored
      if no areas exist an empty list is returned

    Preconditions:
    (1) PowerSync database is initialized
    (2) The user must be authenticated
  */
  Future<List<AreaModel>> getAllAreas();
}