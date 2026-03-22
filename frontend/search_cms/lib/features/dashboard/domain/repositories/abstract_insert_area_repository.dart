import 'package:search_cms/core/utils/class_templates/result.dart';

/*
  The repository interface for inserting an area
*/
abstract class AbstractInsertAreaRepository {
  /*
    Inserts a new Area in the system

    @param name A non-empty name string for the area

    @return A Success containing the inserted AreaEntity, or a Failure
      containing the errorMessage

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) name.isNotEmpty
  */
  Future<Result> insertArea({required String name});
}
