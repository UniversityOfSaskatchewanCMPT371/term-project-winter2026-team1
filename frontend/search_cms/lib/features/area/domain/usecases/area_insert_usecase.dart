import '../../../../core/utils/class_templates/result.dart';
import '../repositories/abstract_area_insert_repository.dart';

/*
  The insert use case for adding a new area
 */
class AreaInsertUsecase {
  final AbstractAreaInsertRepository repository;

  AreaInsertUsecase({required this.repository});

  /*
    The use case for inserting a new area into Supabase

    @param name A String containing the name of the area. Must not be empty.
    @return A Success if insert is successful, containing the AreaEntity or
      Failure containing the errorMessage otherwise

    Preconditions: name.isNotEmpty
   */
  Future<Result> call(String name) async {
    // Assertion for the preconditions
    assert(name.isNotEmpty);

    Result result = await repository.insertArea(name);
    return result;
  }
}
