import '../entities/site_area_entity.dart';
import '../repositories/abstract_dashboard_repository.dart';

class GetAllSiteAreasUseCase {
  final AbstractDashboardRepository repository;

  GetAllSiteAreasUseCase(this.repository);

  Future<List<SiteAreaEntity>> call() {
    return repository.getAllSiteAreas();
  }
}