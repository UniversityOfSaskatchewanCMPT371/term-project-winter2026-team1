import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'abstract_insert_unit_api.dart';

/*
  The PowerSync API implementation for inserting a unit
*/
class InsertUnitApiImpl implements AbstractInsertUnitApi {
  final PowerSyncDatabase _powerSyncDatabase;
  final Logger _logger = Logger('Insert unit API');

  InsertUnitApiImpl({required PowerSyncDatabase powerSyncDatabase})
      : _powerSyncDatabase = powerSyncDatabase;

  /*
    Inserts a new Unit record into the PowerSync local database

    @param siteId A valid UUID reference to an existing site
    @param name A non-empty name string for the unit

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) siteName.isNotEmpty && name.isNotEmpty

    Postconditions: new unit record is inserted into the database
  */
  @override
  Future<void> insertUnit({required String siteName, required String name}) async {
    try {
      _logger.finer('Insert unit API: Inserting unit into PowerSync '
          'Database start');

      assert(_powerSyncDatabase.currentStatus.anyError == null);
      assert(getIt<SupabaseClient>().auth.currentSession != null);
      assert(siteName.isNotEmpty);
      assert(name.isNotEmpty);

      final String now = DateTime.now().toUtc().toIso8601String();

      // use the site name to resolve the site ID
      final siteId = await _powerSyncDatabase.execute(
        'SELECT id FROM site WHERE name = ? LIMIT 1',
        [siteName],
      );

      // insert the unit into the site with resolved ID
      await _powerSyncDatabase.execute(
        'INSERT INTO unit (site_id, name, created_at, updated_at) '
        'VALUES (?, ?, ?, ?)',
        [siteId, name, now, now],
      );

      _logger.finer('Insert unit API: Inserting unit into PowerSync '
          'Database end');
    } catch (e) {
      rethrow;
    }
  }
}
