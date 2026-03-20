import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/class_templates/result.dart';
import '../repositories/abstract_get_all_levels_repository.dart';

/*
  The use case for getting all Levels
*/
class GetAllLevelsUseCase {
  // The get all areas repository instance
  final AbstractGetAllLevelsRepository _repository;
  final Logger _logger = Logger('Get all levels use case');

  GetAllLevelsUseCase({required AbstractGetAllLevelsRepository repository})
    : _repository = repository;

  /*
    Retrieves all Levels in the system

    @return A Success if the fetch is successful, containing the list of level
      entities or Failure containing the errorMessage otherwise

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  Future<Result> call() async {
    _logger.finer('Get all levels use case: Retrieving all levels from '
        'PowerSync Database start');

    /*
       Check if the PowerSync database has error, if not, we see it as
       initialized.
       */
    assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
    // Check if the user is authenticated
    assert(getIt<SupabaseClient>().auth.currentSession != null);

    // Call the repository to get all levels
    Result result = await _repository.getAllLevels();

    _logger.finer('Get all levels use case: Retrieving all levels from '
        'PowerSync Database end');

    return result;
  }
}
