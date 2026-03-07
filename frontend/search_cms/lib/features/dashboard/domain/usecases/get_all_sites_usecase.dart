import '../entities/site_entity.dart';
import '../repositories/abstract_dashboard_repository.dart';

class GetAllSitesUseCase {
  final AbstractDashboardRepository repository;

  GetAllSitesUseCase(this.repository);

  Future<List<SiteEntity>> call() {
    return repository.getAllSites();
  }
}