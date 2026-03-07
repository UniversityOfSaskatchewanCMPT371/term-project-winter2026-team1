import '../entities/level_entity.dart';
import '../repositories/abstract_dashboard_repository.dart';

class GetAllLevelsUseCase {
  final AbstractDashboardRepository repository;

  GetAllLevelsUseCase(this.repository);

  Future<List<LevelEntity>> call() {
    return repository.getAllLevels();
  }
}