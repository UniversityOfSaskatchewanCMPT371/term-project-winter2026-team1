import '../entities/level_entity.dart';
import '../repositories/abstract_dashboard_repository.dart';

/*
  The use case for getting all Levels
*/
class GetAllLevelsUseCase {
  final AbstractDashboardRepository repository;

  GetAllLevelsUseCase(this.repository);

  /*
    Retrieves all Levels in the system

    @return A list containing all LevelEntity objects currently stored, 
      if no levels exist an empty list is returned

    Preconditions: None
  */
  Future<List<LevelEntity>> call() {
    return repository.getAllLevels();
  }
}