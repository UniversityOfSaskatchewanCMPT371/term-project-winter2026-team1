import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/abstract_insert_assemblage_repository.dart';

/*
  The use case for inserting an Assemblage
*/
class InsertAssemblageUsecase {
  final AbstractInsertAssemblageRepository _repository;
  final Logger _logger = Logger('Insert unit use case');

  InsertAssemblageUsecase({required AbstractInsertAssemblageRepository repository})
      : _repository = repository;

  /*
    Inserts a new Assemblage in the system

    @param name: optional name of assembalge
    @param unitName: non-empty name string for the associcated Unit
    @param levelName: non-empty name string for associated Level

    @return A Success if the insert is successful, or a Failure
      containing the errorMessage

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) unitName.isNotEmpty && levelName.isNotEmpty
  */
  Future<Result> call({String? name, required String unitName, required String levelName}) async {
    _logger.finer('Insert assemblage use case: Inserting assemblage into PowerSync '
        'Database start');

    assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
    assert(getIt<SupabaseClient>().auth.currentSession != null);

    Result result = await _repository.insertAssemblage(name: name, unitName: unitName, levelName: levelName);

    _logger.finer('Insert assemblage use case: Inserting assemblage into PowerSync '
        'Database end');

    return result;
  }
}
