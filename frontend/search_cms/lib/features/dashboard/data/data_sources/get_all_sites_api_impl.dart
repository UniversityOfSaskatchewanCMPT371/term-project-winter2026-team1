<<<<<<< HEAD
// ignore_for_file: directives_ordering
import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/data/models/site_model.dart';
import 'abstract_get_all_sites_api.dart';
=======
import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'abstract_get_all_sites_api.dart';
import 'package:search_cms/features/dashboard/data/models/site_model.dart';
import 'package:sqlite3/src/result_set.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
>>>>>>> 1d4141e (Get all sites use case is complete.)

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
<<<<<<< HEAD
      _logger.finer('Get all sites API: Retrieving all sites from PowerSync '
          'Database start');
=======
      _logger.finer('Get all sites API start');
>>>>>>> 1d4141e (Get all sites use case is complete.)

      /*
       Check if the PowerSync database has error, if not, we see it as
       initialized.
       */
      assert(_powerSyncDatabase.currentStatus.anyError == null);
      // Check if the user is authenticated
      assert(getIt<SupabaseClient>().auth.currentSession != null);

      // Query the site table
<<<<<<< HEAD
      final result = await _powerSyncDatabase.getAll(
=======
      final ResultSet result = await _powerSyncDatabase.getAll(
>>>>>>> 1d4141e (Get all sites use case is complete.)
        'SELECT * FROM site');

      _logger.finest(result);

      List<SiteModel> listOfSiteModel = [];

      // Create the site models
      for (final row in result) {
        SiteModel siteModel = SiteModel.fromRow(row);
        listOfSiteModel.add(siteModel);
      }

<<<<<<< HEAD
      _logger.finer('Get all sites API: Retrieving all sites from PowerSync '
          'Database end');
=======
      _logger.finer('Get all sites API end');
>>>>>>> 1d4141e (Get all sites use case is complete.)

      return listOfSiteModel;
    } catch (e) {
      rethrow;
    }
  }
}
