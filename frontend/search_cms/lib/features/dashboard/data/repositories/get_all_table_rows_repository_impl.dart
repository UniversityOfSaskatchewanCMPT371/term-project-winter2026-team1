import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/data/models/table_row_model.dart';
import 'package:search_cms/features/dashboard/domain/entities/table_row_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/class_templates/result.dart';
import '../../domain/entities/get_all_table_rows_result_classes.dart'
    as get_all_table_rows_result_classes;
import '../../domain/repositories/abstract_get_all_table_rows_repository.dart';
import '../data_sources/abstract_get_all_table_rows_api.dart';

/*
  The repository implementation for retrieving all table rows
 */
class GetAllTableRowsRepositoryImpl implements AbstractGetAllTableRowsRepository {
  final AbstractGetAllTableRowsApi _api;
  final Logger _logger = Logger('Get all table rows repository');

  GetAllTableRowsRepositoryImpl({required AbstractGetAllTableRowsApi api}) : _api = api;

  /*
    Retrieves all Table Rows in the system

    @return A Success if login is successful, containing the list of Table row
      entities or Failure containing the errorMessage otherwise

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  @override
  Future<Result> getAllTableRows() async {
    try {
      _logger.finer('Get all table rows repository: Retrieving all table rows from '
          'PowerSync Database start');

      /*
       Check if the PowerSync database has error, if not, we see it as
       initialized.
       */
      assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
      // Check if the user is authenticated
      assert(getIt<SupabaseClient>().auth.currentSession != null);

      // Call the api to get the table row models
      List<TableRowModel> listOfTableRowModel = await _api.getAllTableRows();

      List<TableRowEntity> listOfTableRowEntity = [];

      // Convert the table row models to table row entities
      for (final TableRowModel tableRowModel in listOfTableRowModel) {
        TableRowEntity tableRowEntity = tableRowModel.toEntity();
        listOfTableRowEntity.add(tableRowEntity);
      }

      _logger.finer('Get all table rows repository: Retrieving all table rows from '
          'PowerSync Database end');

      return get_all_table_rows_result_classes.Success(
        listOfTableRowEntity: listOfTableRowEntity,
      );
    } catch (e) {
      return get_all_table_rows_result_classes.Failure(errorMessage: e.toString());
    }
  }
}
