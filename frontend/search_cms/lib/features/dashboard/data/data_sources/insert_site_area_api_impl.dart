import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'abstract_insert_site_area_api.dart';

/*
  The PowerSync API implementation for inserting a site_area relationship
*/
class InsertSiteAreaApiImpl implements AbstractInsertSiteAreaApi {
  final PowerSyncDatabase _powerSyncDatabase;
  final Logger _logger = Logger('Insert site area API');

  InsertSiteAreaApiImpl({required PowerSyncDatabase powerSyncDatabase})
      : _powerSyncDatabase = powerSyncDatabase;

  /*
    Inserts a new site_area record into the PowerSync local database

    @param siteId A valid UUID reference to an existing site
    @param areaId A valid UUID reference to an existing area

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) siteId.isNotEmpty && areaId.isNotEmpty

    Postconditions: new site_area record is inserted into the database
  */
  @override
  Future<void> insertSiteArea({
    required String siteId,
    required String areaId,
  }) async {
    try {
      _logger.finer('Insert site area API: Inserting site_area into PowerSync '
          'Database start');

      assert(_powerSyncDatabase.currentStatus.anyError == null);
      assert(getIt<SupabaseClient>().auth.currentSession != null);
      assert(siteId.isNotEmpty);
      assert(areaId.isNotEmpty);

      // generate random UUID
      final String id = const Uuid().v4();

      await _powerSyncDatabase.execute(
        'INSERT INTO site_area (id, site_id, area_id) VALUES (?, ?, ?)',
        [id, siteId, areaId],
      );

      _logger.finer('Insert site area API: Inserting site_area into PowerSync '
          'Database end');
    } catch (e) {
      rethrow;
    }
  }
}
