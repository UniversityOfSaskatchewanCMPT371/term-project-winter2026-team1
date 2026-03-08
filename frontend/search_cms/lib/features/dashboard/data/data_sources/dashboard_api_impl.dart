import '../models/area_model.dart';
import '../models/level_model.dart';
import '../models/site_area_model.dart';
import '../models/site_model.dart';
import '../models/unit_model.dart';
import 'abstract_dashboard_api.dart';

/* 
  The api implementation for the dashboard feature
*/
// (TODO) implement these functions
class DashboardApiImpl implements AbstractDashboardApi {
  /*
    Retrieves all Site records from the database

    @return A list containing all SiteModel objects currently stored
      if no sites exist an empty list is returned

    Preconditions: database connection must be available
  */
  @override
  Future<List<SiteModel>> getAllSites() async {
    throw UnimplementedError();
  }

  /*
    Retrieves all Area records from the database

    @return A list containing all AreaModel objects currently stored
      if no areas exist an empty list is returned

    Preconditions: database connection must be available
  */
  @override
  Future<List<AreaModel>> getAllAreas() async {
    throw UnimplementedError();
  }

  /*
    Retrieves all SiteArea relationship records

    @return A list containing all SiteAreaModel objects currently stored
      if no site areas exist an empty list is returned

    Preconditions: database connection must be available
  */
  @override
  Future<List<SiteAreaModel>> getAllSiteAreas() async {
    throw UnimplementedError();
  }

  /*
    Retrieves all Unit records from the database

    @return A list containing all UnitModel objects currently stored
      if no units exist an empty list is returned

    Preconditions: database connection must be available
  */
  @override
  Future<List<UnitModel>> getAllUnits() async {
    throw UnimplementedError();
  }

  /*
    Retrieves all Level records from the database

    @return A list containing all LevelModel objects currently stored, 
      if no levels exist an empty list is returned

    Preconditions: database connection must be available
  */
  @override
  Future<List<LevelModel>> getAllLevels() async {
    throw UnimplementedError();
  }

  /*
    Creates a new Site record in the database

    @param borden A non-empty borden string with a maximum length of 8 characters
    @param name An optional name for the site

    Preconditions: borden is not empty and borden.length <= 8, database connection must be available

    Postconditions: new site record is inserted into database
  */
  @override
  Future<void> createSite({
    required String borden,
    String? name,
  }) async {
    throw UnimplementedError();
  }

  /*
    Creates a new Area record in the database

    @param name A non-empty name string for the area

    Preconditions: name is not empty, database connection must be available

    Postconditions: new area record is inserted into the database
  */
  @override
  Future<void> createArea({
    required String name,
  }) async {
    throw UnimplementedError();
  }

  /*
    Creates a new SiteArea record in the database (relationship between a site and an area)

    @param siteId A reference to an existing site
    @param areaId A reference to an existing area

    Preconditions: siteId is a valid UUID reference to an existing site, 
      areaId is a valid UUID reference to an existing area, database connection must be available

    Postconditions: new site-area record is inserted into the database
  */
  @override
  Future<void> createSiteArea({
    required String siteId,
    required String areaId,
  }) async {
    throw UnimplementedError();
  }

  /*
    Creates a new Unit record in the database

    @param siteId A reference to an existing site
    @param name A non-empty name string for the unit

    Preconditions: siteId is a valid UUID reference to an existing site, name is not empty,
      database connection must be available

    Postconditions: new unit record is inserted into the database
  */
  @override
  Future<void> createUnit({
    required String siteId,
    required String name,
  }) async {
    throw UnimplementedError();
  }

  /*
    Creates a new Level record in the database

    @param unitId A reference to an existing unit
    @param name A non-empty name string for the level
    @param upLimit An integer representing the upper depth limit in cm
    @param lowLimit An integer representing the lower depth limit in cm
    @param parentId An optional reference to an existing level which is the level's parent
    @param levelChar An optional string representing some other archeological data
    @param levelInt An optional integer representing some other archeological data

    Preconditions: upLimit <= lowLimit, unitId is a valid UUID reference to an existing unit, 
      name is not empty, database connection must be available

    Postconditions: new level record is inserted into the database
  */
  @override
  Future<void> createLevel({
    required String unitId, 
    required String name, 
    required int upLimit, 
    required int lowLimit, 
    String? parentId, 
    String? levelChar, 
    int? levelInt
  }) async {
    throw UnimplementedError();
  }
}