import '../../../../core/utils/class_templates/result.dart';

abstract class AbstractSiteInsertRepository {
  /*
    The repository function for inserting a new site into Supabase

    @param name A String containing the name of the site. Can be empty.
    @param borden A String containing the Borden classification code.
      Max 8 characters and must be unique.
    @return A Success if insert is successful, containing the SiteEntity or
      Failure containing the errorMessage otherwise

    Preconditions: borden.length <= 8 && borden.isNotEmpty
    Postconditions: A Result children class Success or Failure will be returned
   */
  Future<Result> insertSite(String name, String borden);
}
