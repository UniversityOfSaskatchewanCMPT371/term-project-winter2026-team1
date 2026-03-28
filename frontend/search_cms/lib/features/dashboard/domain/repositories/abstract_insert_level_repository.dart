import 'package:search_cms/core/utils/class_templates/result.dart';

/*
  The repository interface for inserting a level
*/
abstract class AbstractInsertLevelRepository {
  /*
    Inserts a new Level in the system

    @param unitId A valid UUID reference to an existing unit
    @param name A non-empty name string for the level
    @param upLimit An integer representing the upper depth limit in cm
    @param lowLimit An integer representing the lower depth limit in cm
    @param parentId An optional reference to an existing level which is the level's parent
    @param levelChar An optional string representing some other archeological data
    @param levelInt An optional integer representing some other archeological data

    @return A Success if the insert is successful, or a Failure
      containing the errorMessage

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) unitId.isNotEmpty && name.isNotEmpty && upLimit <= lowLimit
  */
  Future<Result> insertLevel({
    required String unitId,
    required String name,
    required int upLimit,
    required int lowLimit,
    String? parentId,
    String? levelChar,
    int? levelInt,
  });
}
