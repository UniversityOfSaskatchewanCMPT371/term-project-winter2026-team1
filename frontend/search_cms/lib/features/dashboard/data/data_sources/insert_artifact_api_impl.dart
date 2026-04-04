import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'abstract_insert_artifact_api.dart';


/*
  The PowerSync API implementation for inserting a faunal artifact
*/
class InsertArtifactApiImpl implements AbstractInsertArtifactApi {
  final PowerSyncDatabase _powerSyncDatabase;
  final Logger _logger = Logger('Insert artifact API');

  InsertArtifactApiImpl({required PowerSyncDatabase powerSyncDatabase})
      : _powerSyncDatabase = powerSyncDatabase;

  /*
    Inserts a new faunal artifact record into the database

    @param assemblageName: non-empty name of associated assemblage
    Optional parameters:
    @param porosity: int 1-5
    @param sizeUpper: lower bound of tuple
    @param sizeLower: upper bound of same tuple
    @param comment: string comment
    @param preExcavFrags: integer, default is 1
    @param postExcavFrags: integer, default is 1
    @param elements: integer, default to 1

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) assemblageName.isNotEmpty && sizeUpper <= sizeLower if non-null

    Postconditions: new artifact record is inserted into the database
  */
  @override
  Future<void> insertArtifact({
    required String assemblageName,
    int? porosity,
    double? sizeUpper,
    double? sizeLower,
    String? comment,
    int? preExcavFrags,
    int? postExcavFrags,
    int? elements
  }) async {
    try {
      _logger.finer('Insert artifact API: Inserting artifact into PowerSync '
          'Database start');

      assert(_powerSyncDatabase.currentStatus.anyError == null);
      assert(getIt<SupabaseClient>().auth.currentSession != null);
      assert(assemblageName.isNotEmpty);

      // resolve assemblage ID from the assemblage name
      final result = await _powerSyncDatabase.execute(
        'SELECT id FROM assemblage WHERE name = ? LIMIT 1',
        [assemblageName],
      );
      assert(result.rows.isNotEmpty);
      // query returns a ResultSet so we extract the ID here
      final String assemblageId = result.first['id'] as String;

      // generate random UUID
      final String id = const Uuid().v4();

      final String now = DateTime.now().toUtc().toIso8601String();

      // use the resolved assemblage ID to insert the artifact with all given fields into that assemblage
      await _powerSyncDatabase.execute(
        'INSERT INTO artifact_faunal (id, assemblage_id, porosity, size_upper, size_lower, comment, pre_excav_frags, post_excav_frags, elements, created_at, updated_at)'
        'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [id, assemblageId, porosity, sizeUpper, sizeLower, comment, preExcavFrags, postExcavFrags, elements, now, now],
      );

      _logger.finer('Insert artifact API: Inserting artifact into PowerSync '
          'Database end');
    } catch (e) {
      rethrow;
    }
  }
}