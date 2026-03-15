import 'package:search_cms/core/utils/class_templates/result.dart';

/*
  The repository interface for retrieving all sites
 */
abstract class AbstractGetAllSitesRepository {
  /*
    Retrieves all Sites in the system

<<<<<<< HEAD
    @return A Success if the fetch is successful, containing the list of site
=======
    @return A Success if login is successful, containing the list of site
>>>>>>> 1d4141e (Get all sites use case is complete.)
      entities or Failure containing the errorMessage otherwise

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  Future<Result> getAllSites();
}