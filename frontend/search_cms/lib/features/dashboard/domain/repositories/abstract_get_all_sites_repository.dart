import 'package:search_cms/core/utils/class_templates/result.dart';

/*
  The repository interface for retrieving all sites
 */
abstract class AbstractGetAllSitesRepository {
  /*
    Retrieves all Sites in the system

    @return A Success if login is successful, containing the list of site
      entities or Failure containing the errorMessage otherwise

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  Future<Result> getAllSites();
}