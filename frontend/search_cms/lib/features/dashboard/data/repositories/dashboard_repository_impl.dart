import '../../domain/entities/area_entity.dart';
import '../../domain/entities/level_entity.dart';
import '../../domain/entities/site_area_entity.dart';
import '../../domain/entities/site_entity.dart';
import '../../domain/entities/unit_entity.dart';
import '../../domain/repositories/abstract_dashboard_repository.dart';
import '../data_sources/abstract_dashboard_api.dart';

/*
  The repository implementation for mapping between the data layer and the domain layer
  for the dashboard feature
 */
// (TODO) implement these functions
class DashboardRepositoryImpl implements AbstractDashboardRepository {
  /*
    This is the interface for the api for the dashboard
    We will pass in the actual implementation for the api here
  */
  final AbstractDashboardApi api;
  DashboardRepositoryImpl(this.api);

  /*
    Retrieves all Sites in the system

    @return A list containing all SiteEntity objects currently stored
      if no sites exist an empty list is returned

    Preconditions: None
  */
  @override
  Future<List<SiteEntity>> getAllSites() async {
    throw UnimplementedError();
  }

  /*
    Retrieves all Areas in the system

    @return A list containing all AreaEntity objects currently stored
      if no areas exist an empty list is returned

    Preconditions: None
  */
  @override
  Future<List<AreaEntity>> getAllAreas() async {
    throw UnimplementedError();
  }

  /*
    Retrieves all SiteAreas in the system

    @return A list containing all SiteAreaEntity objects currently stored
      if no site areas exist an empty list is returned

    Preconditions: None
  */
  @override
  Future<List<SiteAreaEntity>> getAllSiteAreas() async {
    throw UnimplementedError();
  }

  /*
    Retrieves all Units in the system

    @return A list containing all UnitEntity objects currently stored
      if no units exist an empty list is returned

    Preconditions: None
  */
  @override
  Future<List<UnitEntity>> getAllUnits() async {
    throw UnimplementedError();
  }

  /*
    Retrieves all Levels in the system

    @return A list containing all LevelEntity objects currently stored, 
      if no levels exist an empty list is returned

    Preconditions: None
  */
  @override
  Future<List<LevelEntity>> getAllLevels() async {
    throw UnimplementedError();
  }

  /*
    Creates a new Site in the system

    @param borden A non-empty borden string with a maximum length of 8 characters
    @param name An optional name for the site

    Preconditions: borden is not empty and borden.length <= 8

    Postconditions: new Site is created
  */
  @override
  Future<void> createSite({
    required String borden,
    String? name,
  }) async {
    throw UnimplementedError();
  }

  /*
    Creates a new Area in the system

    @param name A non-empty name string for the area

    Preconditions: name is not empty

    Postconditions: new Area is created
  */
  @override
  Future<void> createArea({
    required String name,
  }) async {
    throw UnimplementedError();
  }

  /*
    Creates a new SiteArea relationship in the system

    @param siteId A reference to an existing site
    @param areaId A reference to an existing area

    Preconditions: siteId is a valid UUID reference to an existing site, 
      areaId is a valid UUID reference to an existing area

    Postconditions: new SiteArea is created
  */
  @override
  Future<void> createSiteArea({
    required String siteId,
    required String areaId,
  }) async {
    throw UnimplementedError();
  }

  /*
    Creates a new Unit in the system

    @param siteId A reference to an existing site
    @param name A non-empty name string for the unit

    Preconditions: siteId is a valid UUID reference to an existing site, name is not empty

    Postconditions: new Unit is created
  */
  @override
  Future<void> createUnit({
    required String siteId,
    required String name,
  }) async {
    throw UnimplementedError();
  }

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