import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'abstract_insert_level_api.dart';

/*
  The PowerSync API implementation for inserting a level
*/
class InsertLevelApiImpl implements AbstractInsertLevelApi {
  final PowerSyncDatabase _powerSyncDatabase;
  final Logger _logger = Logger('Insert level API');

  InsertLevelApiImpl({required PowerSyncDatabase powerSyncDatabase})
      : _powerSyncDatabase = powerSyncDatabase;

  /*
    Inserts a new Level record into the PowerSync local database

    @param unitId A valid UUID reference to an existing unit
    @param name A non-empty name string for the level
    @param upLimit An integer representing the upper depth limit in cm
    @param lowLimit An integer representing the lower depth limit in cm
    @param parentId An optional reference to an existing level which is the level's parent
    @param levelChar An optional string representing some other archeological data
    @param levelInt An optional integer representing some other archeological data

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) unitId.isNotEmpty && name.isNotEmpty && upLimit <= lowLimit

    Postconditions: new level record is inserted into the database
  */
  @override
  Future<void> insertLevel({
    required String unitId,
    required String name,
    required int upLimit,
    required int lowLimit,
    String? parentId,
    String? levelChar,
    int? levelInt,
  }) async {
    try {
      _logger.finer('Insert level API: Inserting level into PowerSync '
          'Database start');

      assert(_powerSyncDatabase.currentStatus.anyError == null);
      assert(getIt<SupabaseClient>().auth.currentSession != null);
      assert(unitId.isNotEmpty);
      assert(name.isNotEmpty);
      assert(upLimit <= lowLimit);

      final String now = DateTime.now().toUtc().toIso8601String();

      await _powerSyncDatabase.execute(
        'INSERT INTO level (unit_id, name, up_limit, low_limit, created_at, '
        'updated_at, parent_id, level_char, level_int) '
        'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [unitId, name, upLimit, lowLimit, now, now, parentId, levelChar, levelInt],
      );

      _logger.finer('Insert level API: Inserting level into PowerSync '
          'Database end');
    } catch (e) {
      rethrow;
    }
  }
}
