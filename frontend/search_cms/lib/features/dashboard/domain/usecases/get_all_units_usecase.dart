import '../entities/unit_entity.dart';
import '../repositories/abstract_dashboard_repository.dart';

class GetAllUnitsUseCase {
  final AbstractDashboardRepository repository;

  GetAllUnitsUseCase(this.repository);

  Future<List<UnitEntity>> call() {
    return repository.getAllUnits();
  }
}