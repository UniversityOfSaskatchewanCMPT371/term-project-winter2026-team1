import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/class_templates/result.dart';
import '../../domain/entities/insert_site_area_result_classes.dart'
    as insert_site_area_result_classes;
import '../../domain/repositories/abstract_insert_site_area_repository.dart';
import '../data_sources/abstract_insert_site_area_api.dart';

/*
  The repository implementation for inserting a site_area relationship
*/
class InsertSiteAreaRepositoryImpl implements AbstractInsertSiteAreaRepository {
  final AbstractInsertSiteAreaApi _api;
  final Logger _logger = Logger('Insert site area repository');

  InsertSiteAreaRepositoryImpl({required AbstractInsertSiteAreaApi api})
      : _api = api;

  /*
    Inserts a new site_area relationship in the system

    @return A Success if the insert is successful, or a Failure
      containing the errorMessage

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) siteId.isNotEmpty && areaId.isNotEmpty
  */
  @override
  Future<Result> insertSiteArea({
    required String siteId,
    required String areaId,
  }) async {
    try {
      _logger.finer('Insert site area repository: Inserting site_area into '
          'PowerSync Database start');

      assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
      assert(getIt<SupabaseClient>().auth.currentSession != null);

      await _api.insertSiteArea(siteId: siteId, areaId: areaId);

      _logger.finer('Insert site area repository: Inserting site_area into '
          'PowerSync Database end');

      return const insert_site_area_result_classes.Success();
    } catch (e) {
      return insert_site_area_result_classes.Failure(errorMessage: e.toString());
    }
  }
}
