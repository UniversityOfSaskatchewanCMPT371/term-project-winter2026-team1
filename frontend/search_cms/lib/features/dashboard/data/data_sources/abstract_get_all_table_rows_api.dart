import 'package:search_cms/features/dashboard/data/models/table_row_model.dart';

/*
  The PowerSync API interface for retrieving all table rows 
 */
abstract class AbstractGetAllTableRowsApi {
  /*
    Retrieves all table row records from the database

    @return A list containing all TableRowModel objects currently stored
      if no table rows exist an empty list is returned

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  Future<List<TableRowModel>> getAllTableRows();
}