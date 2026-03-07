import '../repositories/abstract_dashboard_repository.dart';

class CreateSiteUseCase {
  final AbstractDashboardRepository repository;

  CreateSiteUseCase(this.repository);

  Future<void> call({
    required String borden,
    String? name,
  }) {
    return repository.createSite(
      borden: borden,
      name: name,
    );
  }
}