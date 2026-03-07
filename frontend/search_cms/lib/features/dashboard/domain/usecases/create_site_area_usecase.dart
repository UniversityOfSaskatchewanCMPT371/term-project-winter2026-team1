import '../repositories/abstract_dashboard_repository.dart';

class CreateSiteAreaUseCase {
  final AbstractDashboardRepository repository;

  CreateSiteAreaUseCase(this.repository);

  Future<void> call({
    required String siteId,
    required String areaId,
  }) {
    return repository.createSiteArea(
      siteId: siteId,
      areaId: areaId,
    );
  }
}