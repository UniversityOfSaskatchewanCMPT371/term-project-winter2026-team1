import 'package:search_cms/core/utils/class_templates/result.dart';

/*
  The repository interface for retrieving all table rows 
 */
abstract class AbstractGetAllTableRowsRepository {
  /*
    Retrieves all table rows in the system

    @return A Success if the fetch is successful, containing the list of site
      entities or Failure containing the errorMessage otherwise

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  Future<Result> getAllTableRows();
}