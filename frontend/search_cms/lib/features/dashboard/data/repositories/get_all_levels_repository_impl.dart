import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/features/dashboard/data/data_sources/abstract_get_all_levels_api.dart';
import 'package:search_cms/features/dashboard/domain/entities/level_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/class_templates/result.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/get_all_levels_result_classes.dart'
    as get_all_levels_result_classes;
import '../../domain/repositories/abstract_get_all_levels_repository.dart';
import '../models/level_model.dart';

/*
  The repository implementation for retrieving all levels
 */
class GetAllLevelsRepositoryImpl implements AbstractGetAllLevelsRepository {
  // The api instance for retrieving all levels
  final AbstractGetAllLevelsApi _api;
  final Logger _logger = Logger('Get all levels repository');

  GetAllLevelsRepositoryImpl({required AbstractGetAllLevelsApi api})
    : _api = api;
  /*
    Retrieves all Levels in the system

    @return A list containing all LevelEntity objects currently stored,
      if no levels exist an empty list is returned

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  @override
  Future<Result> getAllLevels() async {
    try {
      _logger.finer(
        'Get all levels repository: Retrieving all levels from '
        'PowerSync Database start',
      );

      /*
       Check if the PowerSync database has error, if not, we see it as
       initialized.
       */
      assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
      // Check if the user is authenticated
      assert(getIt<SupabaseClient>().auth.currentSession != null);

      // Call the api to get the level models
      List<LevelModel> listOfLevelModel = await _api.getAllLevels();

      List<LevelEntity> listOfLevelEntity = [];

      for (LevelModel levelModel in listOfLevelModel) {
        LevelEntity levelEntity = levelModel.toEntity();
        listOfLevelEntity.add(levelEntity);
      }

      _logger.finer(
        'Get all levels repository: Retrieving all levels from '
        'PowerSync Database end',
      );

      return get_all_levels_result_classes.Success(
        listOfLevelEntity: listOfLevelEntity,
      );
    } catch (e) {
      // If the fetch is not successful, return Failure with the error message
      return get_all_levels_result_classes.Failure(errorMessage: e.toString());
    }
  }
}
