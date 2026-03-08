import '../repositories/abstract_dashboard_repository.dart';

/*
  The use case for creating a Unit
*/
class CreateUnitUseCase {
  final AbstractDashboardRepository repository;

  CreateUnitUseCase(this.repository);

  /*
    Creates a new Unit in the system

    @param siteId A reference to an existing site
    @param name A non-empty name string for the unit

    Preconditions: siteId is a valid UUID reference to an existing site, name is not empty

    Postconditions: new Unit is created
  */
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