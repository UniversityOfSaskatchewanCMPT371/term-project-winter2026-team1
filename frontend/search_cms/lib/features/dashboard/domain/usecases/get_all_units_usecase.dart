import '../entities/unit_entity.dart';
import '../repositories/abstract_dashboard_repository.dart';

/*
  The use case for getting all Units
*/
class GetAllUnitsUseCase {
  final AbstractDashboardRepository repository;

  GetAllUnitsUseCase(this.repository);

  /*
    Retrieves all Units in the system

    @return A list containing all UnitEntity objects currently stored
      if no units exist an empty list is returned

    Preconditions: None
  */
  Future<List<UnitEntity>> call() {
    return repository.getAllUnits();
  }
}