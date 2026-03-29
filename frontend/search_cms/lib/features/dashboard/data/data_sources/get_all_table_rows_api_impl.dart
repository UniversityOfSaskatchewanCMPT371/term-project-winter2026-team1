import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/data/models/table_row_model.dart';
import 'abstract_get_all_table_rows_api.dart';

/*
  The PowerSync API implementation for retrieving all table rows 
 */
class GetAllTableRowsApiImpl implements AbstractGetAllTableRowsApi {
  // The PowerSync database instance
  final PowerSyncDatabase _powerSyncDatabase;
  final Logger _logger = Logger('Get all table rows API');

  GetAllTableRowsApiImpl({required PowerSyncDatabase powerSyncDatabase})
    : _powerSyncDatabase = powerSyncDatabase;

  /*
    Retrieves all table row records from the database
    Joins all columns into a single result, one row per artifact

    @return A list containing all TableRowModel objects currently stored
      if no rows exist an empty list is returned

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  @override
  Future<List<TableRowModel>> getAllTableRows() async {
    try {
      _logger.finer('Get all table rows API: Retrieving all table rows from PowerSync '
          'Database start');

      /*
       Check if the PowerSync database has error, if not, we see it as
       initialized.
       */
      assert(_powerSyncDatabase.currentStatus.anyError == null);
      // Check if the user is authenticated
      assert(getIt<SupabaseClient>().auth.currentSession != null);

      // Query all tables using joined SQL query
      final result = await _powerSyncDatabase.getAll('
        SELECT
        site.borden, site.name AS site_name,
        area.name AS area_name,
        unit.name AS unit_name,
        level.name AS level_name, level.up_limit, level.low_limit,
        assemblage.name AS assemblage_name,
        artifact_faunal.porosity, artifact_faunal.size_upper, artifact_faunal.size_lower, 
        artifact_faunal.pre_excav_frags, artifact_faunal.post_excav_frags, artifact_faunal.elements,
        artifact_faunal.comment

        FROM site

        LEFT JOIN unit
        ON site.id = unit.site_id

        LEFT JOIN level
        ON unit.id = level.unit_id

        LEFT JOIN assemblage
        ON level.id = assemblage.level_id

        LEFT JOIN artifact_faunal
        ON assemblage.id = artifact_faunal.assemblage_id


        LEFT JOIN site_area
        ON site.id = site_area.site_id

        LEFT JOIN area
        ON site_area.area_id = area.id

        ORDER BY site.name, area.name, unit.name, level.name, assemblage.name
        ');

      _logger.finest(result);

      List<TableRowModel> listOfTableRowModel = [];

      // Create the table row models
      for (final row in result) {
        TableRowModel tableRowModel = TableRowModel.fromRow(row);
        listOfTableRowModel.add(tableRowModel);
      }

      _logger.finer('Get all table rows API: Retrieving all table rows from PowerSync '
          'Database end');

      return listOfTableRowModel;
    } catch (e) {
      rethrow;
    }
  }
}
