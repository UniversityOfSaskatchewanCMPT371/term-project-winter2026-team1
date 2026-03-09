import '../entities/site_entity.dart';
import '../repositories/abstract_dashboard_repository.dart';

/*
  The use case for getting all Sites
*/
class GetAllSitesUseCase {
  final AbstractDashboardRepository repository;

  GetAllSitesUseCase(this.repository);

  /*
    Retrieves all Sites in the system

    @return A list containing all SiteEntity objects currently stored
      if no sites exist an empty list is returned

    Preconditions: None
  */
  Future<List<SiteEntity>> call() {
    return repository.getAllSites();
  }
}