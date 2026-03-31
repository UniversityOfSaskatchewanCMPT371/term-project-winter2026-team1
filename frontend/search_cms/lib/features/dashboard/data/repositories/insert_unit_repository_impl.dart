import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/class_templates/result.dart';
import '../../domain/entities/insert_unit_result_classes.dart'
    as insert_unit_result_classes;
import '../../domain/repositories/abstract_insert_unit_repository.dart';
import '../data_sources/abstract_insert_unit_api.dart';

/*
  The repository implementation for inserting a unit
*/
class InsertUnitRepositoryImpl implements AbstractInsertUnitRepository {
  final AbstractInsertUnitApi _api;
  final Logger _logger = Logger('Insert unit repository');

  InsertUnitRepositoryImpl({required AbstractInsertUnitApi api}) : _api = api;

  /*
    Inserts a new Unit in the system

    @return A Success if the insert is successful, or a Failure
      containing the errorMessage

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) siteId.isNotEmpty && name.isNotEmpty
  */
  @override
  Future<Result> insertUnit({required String siteId, required String name}) async {
    try {
      _logger.finer('Insert unit repository: Inserting unit into PowerSync '
          'Database start');

      assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
      assert(getIt<SupabaseClient>().auth.currentSession != null);

      await _api.insertUnit(siteId: siteId, name: name);

      _logger.finer('Insert unit repository: Inserting unit into PowerSync '
          'Database end');

      return const insert_unit_result_classes.Success();
    } catch (e) {
      return insert_unit_result_classes.Failure(errorMessage: e.toString());
    }
  }
}
