import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/class_templates/result.dart';
import '../../domain/entities/insert_artifact_result_classes.dart'
    as insert_artifact_result_classes;
import '../../domain/repositories/abstract_insert_artifact_repository.dart';
import '../data_sources/abstract_insert_artifact_api.dart';

/*
  The repository implementation for inserting a faunal artifact
*/
class InsertArtifactRepositoryImpl implements AbstractInsertArtifactRepository {
  final AbstractInsertArtifactApi _api;
  final Logger _logger = Logger('Insert artifact repository');

  InsertArtifactRepositoryImpl({required AbstractInsertArtifactApi api}) : _api = api;

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
  Future<Result> insertArtifact({
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
      _logger.finer('Insert artifact repository: Inserting artifact into PowerSync '
          'Database start');

      assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
      assert(getIt<SupabaseClient>().auth.currentSession != null);

      await _api.insertArtifact(assemblageName: assemblageName, porosity: porosity,
        sizeUpper: sizeUpper, sizeLower: sizeLower, comment: comment, preExcavFrags: preExcavFrags,
        postExcavFrags: postExcavFrags, elements: elements);

      _logger.finer('Insert artifact repository: Inserting artifact into PowerSync '
          'Database end');

      return const insert_artifact_result_classes.Success();
    } catch (e) {
      return insert_artifact_result_classes.Failure(errorMessage: e.toString());
    }
  }
}
