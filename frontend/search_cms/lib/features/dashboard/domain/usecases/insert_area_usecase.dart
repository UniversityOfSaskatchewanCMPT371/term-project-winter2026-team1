import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/abstract_insert_area_repository.dart';

/*
  The use case for inserting an Area
*/
class InsertAreaUsecase {
  final AbstractInsertAreaRepository _repository;
  final Logger _logger = Logger('Insert area use case');

  InsertAreaUsecase({required AbstractInsertAreaRepository repository})
      : _repository = repository;

  /*
    Inserts a new Area in the system

    @param name A non-empty name string for the area

    @return A Success containing the inserted AreaEntity, or a Failure
      containing the errorMessage

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) name.isNotEmpty
  */
  Future<Result> call({required String name}) async {
    _logger.finer('Insert area use case: Inserting area into PowerSync '
        'Database start');

    assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
    assert(getIt<SupabaseClient>().auth.currentSession != null);

    Result result = await _repository.insertArea(name: name);

    _logger.finer('Insert area use case: Inserting area into PowerSync '
        'Database end');

    return result;
  }
}
