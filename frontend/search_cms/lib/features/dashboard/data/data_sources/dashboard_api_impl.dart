import '../models/area_model.dart';
import '../models/level_model.dart';
import '../models/site_area_model.dart';
import '../models/site_model.dart';
import '../models/unit_model.dart';
import 'abstract_dashboard_api.dart';

// implement these functions
class DashboardApiImpl implements AbstractDashboardApi {
  @override
  Future<List<SiteModel>> getAllSites() async {
    throw UnimplementedError();
  }

  @override
  Future<List<AreaModel>> getAllAreas() async {
    throw UnimplementedError();
  }

  @override
  Future<List<SiteAreaModel>> getAllSiteAreas() async {
    throw UnimplementedError();
  }

  @override
  Future<List<UnitModel>> getAllUnits() async {
    throw UnimplementedError();
  }

  @override
  Future<List<LevelModel>> getAllLevels() async {
    throw UnimplementedError();
  }

  @override
  Future<void> createSite({
    required String borden,
    String? name,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> createArea({
    required String name,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> createSiteArea({
    required String siteId,
    required String areaId,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> createUnit({
    required String siteId,
    required String name,
  }) async {
    throw UnimplementedError();
  }

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