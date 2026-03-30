import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/class_templates/result.dart';
import '../../domain/entities/insert_level_result_classes.dart'
    as insert_level_result_classes;
import '../../domain/repositories/abstract_insert_level_repository.dart';
import '../data_sources/abstract_insert_level_api.dart';

/*
  The repository implementation for inserting a level
*/
class InsertLevelRepositoryImpl implements AbstractInsertLevelRepository {
  final AbstractInsertLevelApi _api;
  final Logger _logger = Logger('Insert level repository');

  InsertLevelRepositoryImpl({required AbstractInsertLevelApi api}) : _api = api;

  /*
    Inserts a new Level in the system

    @return A Success if the insert is successful, or a Failure
      containing the errorMessage

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) unitId.isNotEmpty && name.isNotEmpty && upLimit <= lowLimit
  */
  @override
  Future<Result> insertLevel({
    required String unitId,
    required String name,
    required int upLimit,
    required int lowLimit,
    String? parentId,
    String? levelChar,
    int? levelInt,
  }) async {
    try {
      _logger.finer('Insert level repository: Inserting level into PowerSync '
          'Database start');

      assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
      assert(getIt<SupabaseClient>().auth.currentSession != null);

      await _api.insertLevel(
        unitId: unitId,
        name: name,
        upLimit: upLimit,
        lowLimit: lowLimit,
        parentId: parentId,
        levelChar: levelChar,
        levelInt: levelInt,
      );

      _logger.finer('Insert level repository: Inserting level into PowerSync '
          'Database end');

      return const insert_level_result_classes.Success();
    } catch (e) {
      return insert_level_result_classes.Failure(errorMessage: e.toString());
    }
  }
}
