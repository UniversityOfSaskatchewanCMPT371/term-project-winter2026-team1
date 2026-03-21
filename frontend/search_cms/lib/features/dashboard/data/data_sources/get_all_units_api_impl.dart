import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/constants.dart';
import '../models/unit_model.dart';
import 'abstract_get_all_units_api.dart';

/*
  The PowerSync API implementation for retrieving all units
 */
class GetAllUnitsApiImpl implements AbstractGetAllUnitsApi {
  // The PowerSync database instance
  final PowerSyncDatabase _powerSyncDatabase;
  final Logger _logger = Logger('Get all units API');

  GetAllUnitsApiImpl({required PowerSyncDatabase powerSyncDatabase})
    : _powerSyncDatabase = powerSyncDatabase;

  /*
    Retrieves all Unit records from the database

    @return A list containing all UnitModel objects currently stored,
      if no units exist an empty list is returned

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  @override
  Future<List<UnitModel>> getAllUnits() async {
    try {
      _logger.finer('Get all units API: Retrieving all units from PowerSync '
          'Database start');

      /*
       Check if the PowerSync database has error, if not, we see it as
       initialized.
       */
      assert(_powerSyncDatabase.currentStatus.anyError == null);
      // Check if the user is authenticated
      assert(getIt<SupabaseClient>().auth.currentSession != null);

      // Query the unit table
      final result = await _powerSyncDatabase.getAll(
          'SELECT * FROM unit');

      List<UnitModel> listOfUnitModel = [];

      // Create the unit models
      for (final row in result) {
        UnitModel unitModel = UnitModel.fromRow(row);
        listOfUnitModel.add(unitModel);
      }

      _logger.finest(result);

      _logger.finer('Get all units API: Retrieving all units from PowerSync '
          'Database end');

      return listOfUnitModel;
    } catch (e) {
      rethrow;
    }
  }
}
