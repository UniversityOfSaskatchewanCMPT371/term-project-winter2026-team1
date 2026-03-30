import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'abstract_insert_assemblage_api.dart';

/*
  The PowerSync API implementation for inserting an assemblage
*/
class InsertAssemblageApiImpl implements AbstractInsertAssemblageApi {
  final PowerSyncDatabase _powerSyncDatabase;
  final Logger _logger = Logger('Insert assemblage API');

  InsertAssemblageApiImpl({required PowerSyncDatabase powerSyncDatabase})
      : _powerSyncDatabase = powerSyncDatabase;

  /*
    Inserts a new assemblage record into the PowerSync local database

    @param 

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) unitName.isNotEmpty && levelName.isNotEmpty

    Postconditions: new assemblage record is inserted into the database
  */
  @override
  Future<void> insertAssemblage({String? name, required String unitName, required String levelName}) async {
    try {
      _logger.finer('Insert unit API: Inserting assemblage into PowerSync '
          'Database start');

      assert(_powerSyncDatabase.currentStatus.anyError == null);
      assert(getIt<SupabaseClient>().auth.currentSession != null);
      assert(unitName.isNotEmpty);
      assert(levelName.isNotEmpty);

      // resolve unit
      final unitResult = await _powerSyncDatabase.execute(
        'SELECT id FROM unit WHERE name = ? LIMIT 1',
        [unitName],
      );
      final String unitId = unitResult.first['id'] as String;

      // resolve level
      final levelResult = await _powerSyncDatabase.execute(
        'SELECT id FROM level WHERE name = ? AND unit_id = ? LIMIT 1',
        [levelName, unitId],
      );
      final String levelId = levelResult.first['id'] as String;

      // insert
      await _powerSyncDatabase.execute(
        'INSERT INTO assemblage (level_id, name) VALUES (?, ?)',
        [levelId, name],
      );

      _logger.finer('Insert unit API: Inserting Assemblage into PowerSync '
          'Database end');
    } catch (e) {
      rethrow;
    }
  }
}