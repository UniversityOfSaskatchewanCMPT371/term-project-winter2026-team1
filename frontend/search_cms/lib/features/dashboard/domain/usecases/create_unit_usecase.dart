import '../repositories/abstract_dashboard_repository.dart';

class CreateUnitUseCase {
  final AbstractDashboardRepository repository;

  CreateUnitUseCase(this.repository);

  Future<void> call({
    required String siteId,
    required String name,
  }) {
    return repository.createUnit(
      siteId: siteId,
      name: name,
    );
  }
}