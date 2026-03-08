import '../entities/site_area_entity.dart';
import '../repositories/abstract_dashboard_repository.dart';

/*
  The use case for getting all SiteAreas
*/
class GetAllSiteAreasUseCase {
  final AbstractDashboardRepository repository;

  GetAllSiteAreasUseCase(this.repository);

  /*
    Retrieves all SiteAreas in the system

    @return A list containing all SiteAreaEntity objects currently stored
      if no site areas exist an empty list is returned

    Preconditions: None
  */
  Future<List<SiteAreaEntity>> call() {
    return repository.getAllSiteAreas();
  }
}