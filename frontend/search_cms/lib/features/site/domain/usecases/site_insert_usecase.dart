import '../../../../core/utils/class_templates/result.dart';
import '../repositories/abstract_site_insert_repository.dart';

/*
  The insert use case for adding a new site
 */
class SiteInsertUsecase {
  final AbstractSiteInsertRepository repository;

  SiteInsertUsecase({required this.repository});

  /*
    The use case for inserting a new site into Supabase

    @param name A String containing the name of the site. Can be empty.
    @param borden A String containing the Borden classification code.
      Max 8 characters and must be unique.
    @return A Success if insert is successful, containing the SiteEntity or
      Failure containing the errorMessage otherwise

    Preconditions: borden.length <= 8 && borden.isNotEmpty
   */
  Future<Result> call(String name, String borden) async {
    // Assertion for the preconditions
    assert(borden.isNotEmpty && borden.length <= 8);

    Result result = await repository.insertSite(name, borden);
    return result;
  }
}
