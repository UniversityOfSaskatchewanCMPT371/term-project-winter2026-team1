import 'package:search_cms/features/dashboard/data/models/area_model.dart';
import 'package:search_cms/features/dashboard/data/models/level_model.dart';
import 'package:search_cms/features/dashboard/data/models/site_area_model.dart';
import 'package:search_cms/features/dashboard/data/models/site_model.dart';
import 'package:search_cms/features/dashboard/data/models/unit_model.dart';

abstract class AbstractDashboardCrudDataSource {
  // READ operations
  /*
    Retrieves all Site records from the database

    @return A list containing all SiteModel objects currently stored
      if no sites exist an empty list is returned

    Preconditions: database connection must be available
  */
  Future<List<SiteModel>> getAllSites();

  /*
    Retrieves all Area records from the database

    @return A list containing all AreaModel objects currently stored
      if no areas exist an empty list is returned

    Preconditions: database connection must be available
  */
  Future<List<AreaModel>> getAllAreas();

  /*
    Retrieves all SiteArea relationship records

    @return A list containing all SiteAreaModel objects currently stored
      if no site areas exist an empty list is returned

    Preconditions: database connection must be available
  */
  Future<List<SiteAreaModel>> getAllSiteAreas();

  /*
    Retrieves all Unit records from the database

    @return A list containing all UnitModel objects currently stored
      if no units exist an empty list is returned

    Preconditions: database connection must be available
  */
  Future<List<UnitModel>> getAllUnits();

  /*
    Retrieves all Level records from the database

    @return A list containing all LevelModel objects currently stored, 
      if no levels exist an empty list is returned

    Preconditions: database connection must be available
  */
  Future<List<LevelModel>> getAllLevels();
}