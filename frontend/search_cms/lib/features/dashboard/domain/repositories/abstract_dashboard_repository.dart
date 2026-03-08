import '../entities/area_entity.dart';
import '../entities/level_entity.dart';
import '../entities/site_area_entity.dart';
import '../entities/site_entity.dart';
import '../entities/unit_entity.dart';

abstract class AbstractDashboardRepository {
  /*
    Retrieves all Sites in the system

    @return A list containing all SiteEntity objects currently stored
      if no sites exist an empty list is returned

    Preconditions: None
  */
  Future<List<SiteEntity>> getAllSites();

  /*
    Retrieves all Areas in the system

    @return A list containing all AreaEntity objects currently stored
      if no areas exist an empty list is returned

    Preconditions: None
  */
  Future<List<AreaEntity>> getAllAreas();

  /*
    Retrieves all SiteAreas in the system

    @return A list containing all SiteAreaEntity objects currently stored
      if no site areas exist an empty list is returned

    Preconditions: None
  */
  Future<List<SiteAreaEntity>> getAllSiteAreas();

  /*
    Retrieves all Units in the system

    @return A list containing all UnitEntity objects currently stored
      if no units exist an empty list is returned

    Preconditions: None
  */
  Future<List<UnitEntity>> getAllUnits();

  /*
    Retrieves all Levels in the system

    @return A list containing all LevelEntity objects currently stored, 
      if no levels exist an empty list is returned

    Preconditions: None
  */
  Future<List<LevelEntity>> getAllLevels();

  /*
    Creates a new Site in the system

    @param borden A non-empty borden string with a maximum length of 8 characters
    @param name An optional name for the site

    Preconditions: borden is not empty and borden.length <= 8

    Postconditions: new Site is created
  */
  Future<void> createSite({required String borden, String? name});

  /*
    Creates a new Area in the system

    @param name A non-empty name string for the area

    Preconditions: name is not empty

    Postconditions: new Area is created
  */
  Future<void> createArea({required String name});

  /*
    Creates a new SiteArea relationship in the system

    @param siteId A reference to an existing site
    @param areaId A reference to an existing area

    Preconditions: siteId is a valid UUID reference to an existing site, 
      areaId is a valid UUID reference to an existing area

    Postconditions: new SiteArea is created
  */
  Future<void> createSiteArea({required String siteId, required String areaId});

  /*
    Creates a new Unit in the system

    @param siteId A reference to an existing site
    @param name A non-empty name string for the unit

    Preconditions: siteId is a valid UUID reference to an existing site, name is not empty

    Postconditions: new Unit is created
  */
  Future<void> createUnit({required String siteId, required String name});

  /*
    Creates a new Level in the system

    @param unitId A reference to an existing unit
    @param name A non-empty name string for the level
    @param upLimit An integer representing the upper depth limit in cm
    @param lowLimit An integer representing the lower depth limit in cm
    @param parentId An optional reference to an existing level which is the level's parent
    @param levelChar An optional string representing some other archeological data
    @param levelInt An optional integer representing some other archeological data

    Preconditions: upLimit <= lowLimit, unitId is a valid UUID reference to an existing unit, 
      name is not empty

    Postconditions: new Level is created
  */
  Future<void> createLevel({
    required String unitId, 
    required String name, 
    required int upLimit, 
    required int lowLimit, 
    String? parentId, 
    String? levelChar, 
    int? levelInt
  });
}