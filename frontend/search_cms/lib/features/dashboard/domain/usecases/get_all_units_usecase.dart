import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/class_templates/result.dart';
import '../../../../core/utils/constants.dart';
import '../repositories/abstract_get_all_units_repository.dart';

/*
  The use case for getting all Units
*/
class GetAllUnitsUseCase {
  final AbstractGetAllUnitsRepository _repository;
  final Logger _logger = Logger('Get all units use case');

  GetAllUnitsUseCase({required AbstractGetAllUnitsRepository repository})
    : _repository = repository;

  /*
    Retrieves all Units in the system

    @return A Success if the fetch is successful, containing the list of unit
      entities or Failure containing the errorMessage otherwise

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  Future<Result> call() async {
    _logger.finer('Get all units use case: Retrieving all units from '
        'PowerSync Database start');

    /*
       Check if the PowerSync database has error, if not, we see it as
       initialized.
       */
    assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
    // Check if the user is authenticated
    assert(getIt<SupabaseClient>().auth.currentSession != null);

    // Call the repository to get all units
    Result result = await _repository.getAllUnits();

    return result;
  }
}
