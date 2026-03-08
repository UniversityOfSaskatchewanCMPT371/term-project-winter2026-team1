import '../repositories/abstract_dashboard_repository.dart';

/*
  The use case for creating an Site
*/
class CreateSiteUseCase {
  final AbstractDashboardRepository repository;

  CreateSiteUseCase(this.repository);

  /*
    Creates a new Site in the system

    @param borden A non-empty borden string with a maximum length of 8 characters
    @param name An optional name for the site

    Preconditions: borden is not empty and borden.length <= 8

    Postconditions: new Site is created
  */
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