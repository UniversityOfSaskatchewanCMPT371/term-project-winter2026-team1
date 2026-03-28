import 'package:search_cms/core/utils/class_templates/result.dart';

/*
  The repository interface for inserting a unit
*/
abstract class AbstractInsertUnitRepository {
  /*
    Inserts a new Unit in the system

    @param siteId A valid UUID reference to an existing site
    @param name A non-empty name string for the unit

    @return A Success if the insert is successful, or a Failure
      containing the errorMessage

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) siteId.isNotEmpty && name.isNotEmpty
  */
  Future<Result> insertUnit({required String siteId, required String name});
}
