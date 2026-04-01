import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'abstract_insert_site_api.dart';
/*
  The PowerSync API implementation for inserting a site
*/
class InsertSiteApiImpl implements AbstractInsertSiteApi {
  final PowerSyncDatabase _powerSyncDatabase;
  final Logger _logger = Logger('Insert site API');

  InsertSiteApiImpl({required PowerSyncDatabase powerSyncDatabase})
      : _powerSyncDatabase = powerSyncDatabase;

  /*
    Inserts a new Site record into the PowerSync local database

    @param borden A non-empty borden string with a maximum length of 8 characters
    @param name An optional name for the site

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) borden.isNotEmpty && borden.length <= 8

    Postconditions: new site record is inserted into the database
  */
  @override
  Future<void> insertSite({required String borden, String? name}) async {
    try {
      _logger.finer('Insert site API: Inserting site into PowerSync '
          'Database start');

      assert(_powerSyncDatabase.currentStatus.anyError == null);
      assert(getIt<SupabaseClient>().auth.currentSession != null);
      assert(borden.isNotEmpty);
      assert(borden.length <= 8);

      final String now = DateTime.now().toUtc().toIso8601String();

      // generate random UUID
      // only required for inserting a new Site
      final String id = const Uuid().v4();

      await _powerSyncDatabase.execute(
        'INSERT INTO site (id, name, borden, created_at, updated_at) '
        'VALUES (?, ?, ?, ?, ?)',
        [id, name, borden, now, now],
      );

      _logger.finer('Insert site API: Inserting site into PowerSync '
          'Database end');
    } catch (e) {
      rethrow;
    }
  }
}
