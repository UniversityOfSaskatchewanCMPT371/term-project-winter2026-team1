import 'package:search_cms/core/utils/class_templates/result.dart';

/*
  The repository interface for inserting a site_area relationship
*/
abstract class AbstractInsertSiteAreaRepository {
  /*
    Inserts a new site_area relationship in the system

    @param siteId A valid UUID reference to an existing site
    @param areaId A valid UUID reference to an existing area

    @return A Success if the insert is successful, or a Failure
      containing the errorMessage

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) siteId.isNotEmpty && areaId.isNotEmpty
  */
  Future<Result> insertSiteArea({required String siteId, required String areaId});
}
