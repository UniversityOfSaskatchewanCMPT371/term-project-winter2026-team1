// ignore_for_file: directives_ordering
import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/data/models/site_model.dart';
import 'abstract_get_all_sites_api.dart';

/*
  The PowerSync API implementation for retrieving all sites
 */
class GetAllSitesApiImpl implements AbstractGetAllSitesApi {
  // The PowerSync database instance
  final PowerSyncDatabase _powerSyncDatabase;
  final Logger _logger = Logger('Get all sites API');

  GetAllSitesApiImpl({required PowerSyncDatabase powerSyncDatabase})
    : _powerSyncDatabase = powerSyncDatabase;

  /*
    Retrieves all Site records from the database

    @return A list containing all SiteModel objects currently stored
      if no sites exist an empty list is returned

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  @override
  Future<List<SiteModel>> getAllSites() async {
    try {
      _logger.finer('Get all sites API: Retrieving all sites from PowerSync '
          'Database start');

      /*
       Check if the PowerSync database has error, if not, we see it as
       initialized.
       */
      assert(_powerSyncDatabase.currentStatus.anyError == null);
      // Check if the user is authenticated
      assert(getIt<SupabaseClient>().auth.currentSession != null);

      // Query the site table
      final result = await _powerSyncDatabase.getAll(
        'SELECT * FROM site');

      _logger.finest(result);

      List<SiteModel> listOfSiteModel = [];

      // Create the site models
      for (final row in result) {
        SiteModel siteModel = SiteModel.fromRow(row);
        listOfSiteModel.add(siteModel);
      }

      _logger.finer('Get all sites API: Retrieving all sites from PowerSync '
          'Database end');

      return listOfSiteModel;
    } catch (e) {
      rethrow;
    }
  }
}
