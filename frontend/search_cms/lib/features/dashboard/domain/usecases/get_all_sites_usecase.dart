import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/abstract_get_all_sites_repository.dart';

/*
  The use case for getting all Sites
*/
class GetAllSitesUseCase {
  final AbstractGetAllSitesRepository _repository;
  final Logger _logger = Logger('Get all sites use case');

  GetAllSitesUseCase({required AbstractGetAllSitesRepository repository})
    : _repository = repository;

  /*
    Retrieves all Sites in the system

    @return A Success if the fetch is successful, containing the list of site
      entities or Failure containing the errorMessage otherwise

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  Future<Result> call() async {

<<<<<<< HEAD
    _logger.finer('Get all sites use case: Retrieving all sites from '
        'PowerSync Database start');
=======
    _logger.finer('Get all sites use case start');
>>>>>>> 1d4141e (Get all sites use case is complete.)

    /*
       Check if the PowerSync database has error, if not, we see it as
       initialized.
       */
    assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
    // Check if the user is authenticated
    assert(getIt<SupabaseClient>().auth.currentSession != null);

    // Call the repository to get all sites
    Result result = await _repository.getAllSites();

<<<<<<< HEAD
    _logger.finer('Get all sites use case: Retrieving all sites from '
        'PowerSync Database end');
=======
    _logger.finer('Get all sites use case end');
>>>>>>> 1d4141e (Get all sites use case is complete.)

    return result;
  }
}
