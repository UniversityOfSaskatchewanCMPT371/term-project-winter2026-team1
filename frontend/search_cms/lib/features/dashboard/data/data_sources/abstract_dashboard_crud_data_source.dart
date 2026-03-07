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


  // CREATE operations
  /*
    Creates a new Site record in the database

    @param site A SiteModel object representing the site to create

    Preconditions: site.id is a valid UUID, site.borden is not empty and site.borden.length <= 8, 
      database connection must be available

    Postconditions: new site record is inserted into database
  */
  Future<void> createSite(SiteModel site);

  /*
    Creates a new Area record in the database

    @param area A AreaModel object representing the area to create

    Preconditions: area.id is a valid UUID, area.name is not empty, 
      database connection must be available

    Postconditions: new area record is inserted into the database
  */
  Future<void> createArea(AreaModel area);

  /*
    Creates a new SiteArea record in the database (relationship between a site and an area)

    @param siteArea A SiteAreaModel object containing the site_id and area_id

    Preconditions: siteArea.siteId is a reference to a existing site,
      siteArea.areaId is a reference to a existing area, database connection must be available

    Postconditions: new site-area record is inserted into the database
  */
  Future<void> createSiteArea(SiteAreaModel siteArea);

  /*
    Creates a new Unit record in the database

    @param unit A UnitModel object representing the unit to create

    Preconditions: unit.id is a valid UUID, unit.siteId is a reference to a existing site,
      unit.name is not empty, database connection must be available

    Postconditions: new unit record is inserted into the database
  */
  Future<void> createUnit(UnitModel unit);

  /*
    Creates a new Level record in the database

    @param level A LevelModel object representing the level to create

    Preconditions: level.upLimit <= level.lowLimit, level.id is a valid UUID,
      level.unitId is a reference to a existing unit, level.name is not empty, 
      database connection must be available

    Postconditions: new level record is inserted into the database
  */
  Future<void> createLevel(LevelModel level);
}