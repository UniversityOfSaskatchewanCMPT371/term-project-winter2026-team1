import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/abstract_get_all_table_rows_repository.dart';

/*
  The use case for getting all table rows
*/
class GetAllTableRowsUseCase {
  final AbstractGetAllTableRowsRepository _repository;
  final Logger _logger = Logger('Get all table rows use case');

  GetAllTableRowsUseCase({required AbstractGetAllTableRowsRepository repository})
    : _repository = repository;

  /*
    Retrieves all table rows in the system

    @return A Success if the fetch is successful, containing the list of table row
      entities or Failure containing the errorMessage otherwise

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  Future<Result> call() async {

    _logger.finer('Get all table rows use case: Retrieving all table rows from '
        'PowerSync Database start');

    /*
       Check if the PowerSync database has error, if not, we see it as
       initialized.
       */
    assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
    // Check if the user is authenticated
    assert(getIt<SupabaseClient>().auth.currentSession != null);

    // Call the repository to get all table rows  
    Result result = await _repository.getAllTableRows();

    _logger.finer('Get all table rows use case: Retrieving all table rows from '
        'PowerSync Database end');

    return result;
  }
}
