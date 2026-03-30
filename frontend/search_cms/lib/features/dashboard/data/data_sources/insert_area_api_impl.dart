import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'abstract_insert_area_api.dart';

/*
  The PowerSync API implementation for inserting an area
*/
class InsertAreaApiImpl implements AbstractInsertAreaApi {
  final PowerSyncDatabase _powerSyncDatabase;
  final Logger _logger = Logger('Insert area API');

  InsertAreaApiImpl({required PowerSyncDatabase powerSyncDatabase})
      : _powerSyncDatabase = powerSyncDatabase;

  /*
    Inserts a new Area record into the PowerSync local database

    @param name A non-empty name string for the area

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) name.isNotEmpty

    Postconditions: new area record is inserted into the database
  */
  @override
  Future<void> insertArea({required String name}) async {
    try {
      _logger.finer('Insert area API: Inserting area into PowerSync '
          'Database start');

      assert(_powerSyncDatabase.currentStatus.anyError == null);
      assert(getIt<SupabaseClient>().auth.currentSession != null);
      assert(name.isNotEmpty);

      final String now = DateTime.now().toUtc().toIso8601String();

      await _powerSyncDatabase.execute(
        'INSERT INTO area (name, created_at, updated_at) VALUES (?, ?, ?)',
        [name, now, now],
      );

      _logger.finer('Insert area API: Inserting area into PowerSync '
          'Database end');
    } catch (e) {
      rethrow;
    }
  }
}
