import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/abstract_insert_level_repository.dart';

/*
  The use case for inserting a Level
*/
class InsertLevelUsecase {
  final AbstractInsertLevelRepository _repository;
  final Logger _logger = Logger('Insert level use case');

  InsertLevelUsecase({required AbstractInsertLevelRepository repository})
      : _repository = repository;

  /*
    Inserts a new Level in the system

    @param unitName A valid UUID reference to an existing unit
    @param name A non-empty name string for the level
    @param upLimit An integer representing the upper depth limit in cm
    @param lowLimit An integer representing the lower depth limit in cm
    @param parentName An optional reference to an existing level which is the level's parent

    @return A Success if the insert is successful, or a Failure
      containing the errorMessage

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) unitName.isNotEmpty && name.isNotEmpty && upLimit <= lowLimit
  */
  Future<Result> call({
    required String unitName,
    required String name,
    required int upLimit,
    required int lowLimit,
    String? parentName,
  }) async {
    _logger.finer('Insert level use case: Inserting level into PowerSync '
        'Database start');

    assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
    assert(getIt<SupabaseClient>().auth.currentSession != null);

    Result result = await _repository.insertLevel(
      unitName: unitName,
      name: name,
      upLimit: upLimit,
      lowLimit: lowLimit,
      parentName: parentName,
    );

    _logger.finer('Insert level use case: Inserting level into PowerSync '
        'Database end');

    return result;
  }
}
