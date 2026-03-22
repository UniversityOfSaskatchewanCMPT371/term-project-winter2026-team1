import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/abstract_insert_site_area_repository.dart';

/*
  The use case for inserting a site_area relationship
*/
class InsertSiteAreaUsecase {
  final AbstractInsertSiteAreaRepository _repository;
  final Logger _logger = Logger('Insert site area use case');

  InsertSiteAreaUsecase({required AbstractInsertSiteAreaRepository repository})
      : _repository = repository;

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
  Future<Result> call({required String siteId, required String areaId}) async {
    _logger.finer('Insert site area use case: Inserting site_area into '
        'PowerSync Database start');

    assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
    assert(getIt<SupabaseClient>().auth.currentSession != null);

    Result result = await _repository.insertSiteArea(
      siteId: siteId,
      areaId: areaId,
    );

    _logger.finer('Insert site area use case: Inserting site_area into '
        'PowerSync Database end');

    return result;
  }
}
