import '../repositories/abstract_dashboard_repository.dart';

/*
  The use case for creating a SiteArea
*/
class CreateSiteAreaUseCase {
  final AbstractDashboardRepository repository;

  CreateSiteAreaUseCase(this.repository);

  /*
    Creates a new SiteArea relationship in the system

    @param siteId A reference to an existing site
    @param areaId A reference to an existing area

    Preconditions: siteId is a valid UUID reference to an existing site, 
      areaId is a valid UUID reference to an existing area

    Postconditions: new SiteArea is created
  */
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