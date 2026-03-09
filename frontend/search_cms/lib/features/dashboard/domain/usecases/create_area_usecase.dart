import '../repositories/abstract_dashboard_repository.dart';

/*
  The use case for creating an Area
*/
class CreateAreaUseCase {
  final AbstractDashboardRepository repository;

  CreateAreaUseCase(this.repository);

  /*
    Creates a new Area in the system

    @param name A non-empty name string for the area

    Preconditions: name is not empty

    Postconditions: new Area is created
  */
  Future<void> call({
    required String name,
  }) {
    return repository.createArea(
      name: name
    );
  }
}