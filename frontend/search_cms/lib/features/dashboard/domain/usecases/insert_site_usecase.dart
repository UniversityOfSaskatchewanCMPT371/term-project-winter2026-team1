import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/abstract_insert_site_repository.dart';

/*
  The use case for inserting a Site
*/
class InsertSiteUsecase {
  final AbstractInsertSiteRepository _repository;
  final Logger _logger = Logger('Insert site use case');

  InsertSiteUsecase({required AbstractInsertSiteRepository repository})
      : _repository = repository;

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
  Future<Result> call({required String borden, String? name}) async {
    _logger.finer('Insert site use case: Inserting site into PowerSync '
        'Database start');

    assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
    assert(getIt<SupabaseClient>().auth.currentSession != null);

    Result result = await _repository.insertSite(borden: borden, name: name);

    _logger.finer('Insert site use case: Inserting site into PowerSync '
        'Database end');

    return result;
  }
}
