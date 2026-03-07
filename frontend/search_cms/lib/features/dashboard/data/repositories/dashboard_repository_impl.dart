import '../../domain/entities/area_entity.dart';
import '../../domain/entities/level_entity.dart';
import '../../domain/entities/site_area_entity.dart';
import '../../domain/entities/site_entity.dart';
import '../../domain/entities/unit_entity.dart';
import '../../domain/repositories/abstract_dashboard_repository.dart';
import '../data_sources/abstract_dashboard_api.dart';

// maps models to entities
// implement these functions
class DashboardRepositoryImpl implements AbstractDashboardRepository {
  final AbstractDashboardApi api;

  DashboardRepositoryImpl(this.api);

  @override
  Future<List<SiteEntity>> getAllSites() async {
    throw UnimplementedError();
  }

  @override
  Future<List<AreaEntity>> getAllAreas() async {
    throw UnimplementedError();
  }

  @override
  Future<List<SiteAreaEntity>> getAllSiteAreas() async {
    throw UnimplementedError();
  }

  @override
  Future<List<UnitEntity>> getAllUnits() async {
    throw UnimplementedError();
  }

  @override
  Future<List<LevelEntity>> getAllLevels() async {
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