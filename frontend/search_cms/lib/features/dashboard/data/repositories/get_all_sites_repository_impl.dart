import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/data/models/site_model.dart';
import 'package:search_cms/features/dashboard/domain/entities/site_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/class_templates/result.dart';
import '../../domain/entities/get_all_sites_result_classes.dart'
    as get_all_sites_result_classes;
import '../../domain/repositories/abstract_get_all_sites_repository.dart';
import '../data_sources/abstract_get_all_sites_api.dart';

/*
  The repository implementation for retrieving all sites
 */
class GetAllSitesRepositoryImpl implements AbstractGetAllSitesRepository {
  final AbstractGetAllSitesApi _api;
  final Logger _logger = Logger('Get all sites repository');

  GetAllSitesRepositoryImpl({required AbstractGetAllSitesApi api}) : _api = api;

  /*
    Retrieves all Sites in the system

    @return A Success if login is successful, containing the list of site
      entities or Failure containing the errorMessage otherwise

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  @override
  Future<Result> getAllSites() async {
    try {
      _logger.finer('Get all sites repository start');

      /*
       Check if the PowerSync database has error, if not, we see it as
       initialized.
       */
      assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
      // Check if the user is authenticated
      assert(getIt<SupabaseClient>().auth.currentSession != null);

      // Call the api to get the site models
      List<SiteModel> listOfSiteModel = await _api.getAllSites();

      List<SiteEntity> listOfSiteEntity = [];

      // Convert the site models to site entities
      for (final SiteModel siteModel in listOfSiteModel) {
        SiteEntity siteEntity = siteModel.toEntity();
        listOfSiteEntity.add(siteEntity);
      }

      _logger.finer('Get all sites repository end');

      return get_all_sites_result_classes.Success(
        listOfSiteEntity: listOfSiteEntity,
      );
    } catch (e) {
      return get_all_sites_result_classes.Failure(errorMessage: e.toString());
    }
  }
}
