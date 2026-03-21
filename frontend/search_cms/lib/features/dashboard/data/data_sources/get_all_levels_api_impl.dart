import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/features/dashboard/data/data_sources/abstract_get_all_levels_api.dart';
import 'package:search_cms/features/dashboard/data/models/level_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/constants.dart';

/*
  The PowerSync API implementation for retrieving all levels
 */
class GetAllLevelsApiImpl implements AbstractGetAllLevelsApi {
  // The PowerSync database instance
  final PowerSyncDatabase _powerSyncDatabase;
  final Logger _logger = Logger('Get all levels API');

  GetAllLevelsApiImpl({required PowerSyncDatabase powerSyncDatabase})
    : _powerSyncDatabase = powerSyncDatabase;

  /*
    Retrieves all Level records from the database

    @return A list containing all LevelModel objects currently stored,
      if no levels exist an empty list is returned

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  @override
  Future<List<LevelModel>> getAllLevels() async {
    try {
      _logger.finer('Get all levels API: Retrieving all levels from PowerSync '
          'Database start');

      /*
       Check if the PowerSync database has error, if not, we see it as
       initialized.
       */
      assert(_powerSyncDatabase.currentStatus.anyError == null);
      // Check if the user is authenticated
      assert(getIt<SupabaseClient>().auth.currentSession != null);

      // Query the level table
      final result = await _powerSyncDatabase.getAll(
          'SELECT * FROM level');

      _logger.finest(result);

      List<LevelModel> listOfLevelModel = [];

      // Create the level model
      for (final row in result) {
        LevelModel levelModel = LevelModel.fromRow(row);
        listOfLevelModel.add(levelModel);
      }

      _logger.finer('Get all levels API: Retrieving all levels from PowerSync '
          'Database end');

      return listOfLevelModel;
    } catch (e) {
      rethrow;
    }
  }
}
