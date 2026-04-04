import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
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

    @param unitName A valid UUID reference to an existing unit
    @param name A non-empty name string for the level
    @param upLimit An integer representing the upper depth limit in cm
    @param lowLimit An integer representing the lower depth limit in cm
    @param parentName An optional reference to an existing level which is the level's parent

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) unitName.isNotEmpty && name.isNotEmpty && upLimit <= lowLimit

    Postconditions: new level record is inserted into the database
  */
  @override
  Future<void> insertLevel({
    required String unitName,
    required String name,
    required int upLimit,
    required int lowLimit,
    String? parentName,
  }) async {
    try {
      _logger.finer('Insert level API: Inserting level into PowerSync '
          'Database start');

      // for debugging
      // _logger.fine('anyError: ${_powerSyncDatabase.currentStatus.anyError}');
      // _logger.fine('currentSession: ${getIt<SupabaseClient>().auth.currentSession}');
      // _logger.fine('unitName: $unitName, name: $name');

      assert(_powerSyncDatabase.currentStatus.anyError == null);
      assert(getIt<SupabaseClient>().auth.currentSession != null);
      assert(unitName.isNotEmpty);
      assert(name.isNotEmpty);
      assert(upLimit <= lowLimit);

      final String now = DateTime.now().toUtc().toIso8601String();

      // find unitId for given unitName
      final unitResult = await _powerSyncDatabase.execute(
        'SELECT id FROM unit WHERE name = ? LIMIT 1',
        [unitName],
      );
      assert(unitResult.isNotEmpty);
      final String unitId = unitResult.first['id'] as String;

      // if not null, find parent levelId for parent level name
      String? parentId;
      if (parentName != null) {
        final parentResult = await _powerSyncDatabase.execute(
          'SELECT id FROM level WHERE name = ? AND unit_id = ? LIMIT 1',
          [parentName, unitId],
        );
        if (parentResult.rows.isNotEmpty) {
          parentId = parentResult.first['id'] as String;
        }
      }

      // generate random UUID
      final String id = const Uuid().v4();

      // insert level into unit with resolved ID and optionally parent level ID
      // leaves level_char and level_int unused
      await _powerSyncDatabase.execute(
        'INSERT INTO level (id, unit_id, name, up_limit, low_limit, created_at, '
        'updated_at, parent_id) '
        'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        [id, unitId, name, upLimit, lowLimit, now, now, parentId],
      );

      _logger.finer('Insert level API: Inserting level into PowerSync '
          'Database end');

    } catch (e) {
      rethrow;
    }
  }
}
