import '../repositories/abstract_dashboard_repository.dart';

class CreateAreaUseCase {
  final AbstractDashboardRepository repository;

  CreateAreaUseCase(this.repository);

  Future<void> call({
    required String name,
  }) {
    return repository.createArea(
      name: name
    );
  }
}