import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/constants.dart';
import '../models/area_model.dart';
import 'abstract_get_all_areas_api.dart';


/*
  The PowerSync API implementation for retrieving all areas
 */
class GetAllAreasApiImpl implements AbstractGetAllAreasApi {
  // The PowerSync database instance
  final PowerSyncDatabase _powerSyncDatabase;
  final Logger _logger = Logger('Get all areas API');

  GetAllAreasApiImpl({required PowerSyncDatabase powerSyncDatabase})
    : _powerSyncDatabase = powerSyncDatabase;

  /*
    Retrieves all Area records from the database

    @return A list containing all AreaModel objects currently stored
      if no areas exist an empty list is returned

    Preconditions:
    (1) PowerSync database is initialized
    (2) The user must be authenticated
  */
  @override
  Future<List<AreaModel>> getAllAreas() async {
    try {
      _logger.finer('Get all areas API: Retrieving all areas from PowerSync '
          'Database start');
      /*
       Check if the PowerSync database has error, if not, we see it as
       initialized.
       */
      assert(_powerSyncDatabase.currentStatus.anyError == null);
      // Check if the user is authenticated
      assert(getIt<SupabaseClient>().auth.currentSession != null);

      // Query the site table
      final result = await _powerSyncDatabase.getAll(
          'SELECT * FROM area');

      _logger.finest(result);

      List<AreaModel> listOfAreaModel = [];

      // Create the area models
      for (final row in result) {
        AreaModel areaModel = AreaModel.fromRow(row);
        listOfAreaModel.add(areaModel);
      }

      _logger.finer('Get all areas API: Retrieving all areas from PowerSync '
          'Database end');

      return listOfAreaModel;
    } catch (e) {
      rethrow;
    }
  }
}
