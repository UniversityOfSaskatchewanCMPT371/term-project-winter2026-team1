import 'package:search_cms/core/utils/class_templates/result.dart';

/*
  The repository interface for inserting an assemblage
*/
abstract class AbstractInsertAssemblageRepository {
  /*
    Inserts a new Assemblage in the system

    @param name: optional name of Assemblage
    @param unitName: A non-empty name string for associated unit
    @param levelName: A non-empty name string for associated level

    @return A Success if the insert is successful, or a Failure
      containing the errorMessage

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) unitName.isNotEmpty && levelName.isNotEmpty
  */
  Future<Result> insertUnit({String? name, required String unitName, required String levelName});
}