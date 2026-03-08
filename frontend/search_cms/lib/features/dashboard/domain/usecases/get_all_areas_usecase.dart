import '../entities/area_entity.dart';
import '../repositories/abstract_dashboard_repository.dart';

/*
  The use case for getting all Areas
*/
class GetAllAreasUseCase {
  final AbstractDashboardRepository repository;

  GetAllAreasUseCase(this.repository);

  /*
    Retrieves all Areas in the system

    @return A list containing all AreaEntity objects currently stored
      if no areas exist an empty list is returned

    Preconditions: None
  */
  Future<List<AreaEntity>> call() {
    return repository.getAllAreas();
  }
}