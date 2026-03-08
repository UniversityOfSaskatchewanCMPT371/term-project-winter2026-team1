import '../repositories/abstract_dashboard_repository.dart';

/*
  The use case for creating a Level
*/
class CreateLevelUseCase {
  final AbstractDashboardRepository repository;

  CreateLevelUseCase(this.repository);

  /*
    Creates a new Level in the system

    @param unitId A reference to an existing unit
    @param name A non-empty name string for the level
    @param upLimit An integer representing the upper depth limit in cm
    @param lowLimit An integer representing the lower depth limit in cm
    @param parentId An optional reference to an existing level which is the level's parent
    @param levelChar An optional string representing some other archeological data
    @param levelInt An optional integer representing some other archeological data

    Preconditions: upLimit <= lowLimit, unitId is a valid UUID reference to an existing unit, 
      name is not empty

    Postconditions: new Level is created
  */
  Future<void> call({
    required String unitId,
    required String name,
    required int upLimit,
    required int lowLimit,
    String? parentId,
    String? levelChar,
    int? levelInt,
  }) {
    return repository.createLevel(
      unitId: unitId,
      name: name,
      upLimit: upLimit,
      lowLimit: lowLimit,
      parentId: parentId,
      levelChar: levelChar,
      levelInt: levelInt,
    );
  }
}