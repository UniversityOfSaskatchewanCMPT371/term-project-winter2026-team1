import 'package:search_cms/core/utils/class_templates/result.dart';

/*
  The repository interface for inserting a site
*/
abstract class AbstractInsertSiteRepository {
  /*
    Inserts a new Site in the system

    @param borden A non-empty borden string with a maximum length of 8 characters
    @param name An optional name for the site

    @return A Success containing the inserted SiteEntity, or a Failure
      containing the errorMessage

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) borden.isNotEmpty && borden.length <= 8
  */
  Future<Result> insertSite({required String borden, String? name});
}
