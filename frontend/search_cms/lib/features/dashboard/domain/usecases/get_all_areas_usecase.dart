import '../entities/area_entity.dart';
import '../repositories/abstract_dashboard_repository.dart';

class GetAllAreasUseCase {
  final AbstractDashboardRepository repository;

  GetAllAreasUseCase(this.repository);

  Future<List<AreaEntity>> call() {
    return repository.getAllAreas();
  }
}