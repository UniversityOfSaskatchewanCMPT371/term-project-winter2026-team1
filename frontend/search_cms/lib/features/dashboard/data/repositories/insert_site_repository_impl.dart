import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/class_templates/result.dart';
import '../../domain/entities/insert_site_result_classes.dart'
    as insert_site_result_classes;
import '../../domain/repositories/abstract_insert_site_repository.dart';
import '../data_sources/abstract_insert_site_api.dart';

/*
  The repository implementation for inserting a site
*/
class InsertSiteRepositoryImpl implements AbstractInsertSiteRepository {
  final AbstractInsertSiteApi _api;
  final Logger _logger = Logger('Insert site repository');

  InsertSiteRepositoryImpl({required AbstractInsertSiteApi api}) : _api = api;

  /*
    Inserts a new Site in the system

    @return A Success if the insert is successful, or a Failure
      containing the errorMessage

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) borden.isNotEmpty && borden.length <= 8
  */
  @override
  Future<Result> insertSite({required String borden, String? name}) async {
    try {
      _logger.finer('Insert site repository: Inserting site into PowerSync '
          'Database start');

      assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
      assert(getIt<SupabaseClient>().auth.currentSession != null);

      await _api.insertSite(borden: borden, name: name);

      _logger.finer('Insert site repository: Inserting site into PowerSync '
          'Database end');

      return const insert_site_result_classes.Success();
    } catch (e) {
      return insert_site_result_classes.Failure(errorMessage: e.toString());
    }
  }
}
