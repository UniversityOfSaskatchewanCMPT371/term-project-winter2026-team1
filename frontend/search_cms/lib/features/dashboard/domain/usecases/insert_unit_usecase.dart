import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/abstract_insert_unit_repository.dart';

/*
  The use case for inserting a Unit
*/
class InsertUnitUsecase {
  final AbstractInsertUnitRepository _repository;
  final Logger _logger = Logger('Insert unit use case');

  InsertUnitUsecase({required AbstractInsertUnitRepository repository})
      : _repository = repository;

  /*
    Inserts a new Unit in the system

    @param siteId A valid UUID reference to an existing site
    @param name A non-empty name string for the unit

    @return A Success if the insert is successful, or a Failure
      containing the errorMessage

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) siteId.isNotEmpty && name.isNotEmpty
  */
  Future<Result> call({required String siteId, required String name}) async {
    _logger.finer('Insert unit use case: Inserting unit into PowerSync '
        'Database start');

    assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
    assert(getIt<SupabaseClient>().auth.currentSession != null);

    Result result = await _repository.insertUnit(siteId: siteId, name: name);

    _logger.finer('Insert unit use case: Inserting unit into PowerSync '
        'Database end');

    return result;
  }
}
