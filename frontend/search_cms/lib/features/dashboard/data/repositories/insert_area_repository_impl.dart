import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/class_templates/result.dart';
import '../../domain/entities/insert_area_result_classes.dart'
    as insert_area_result_classes;
import '../../domain/repositories/abstract_insert_area_repository.dart';
import '../data_sources/abstract_insert_area_api.dart';

/*
  The repository implementation for inserting an area
*/
class InsertAreaRepositoryImpl implements AbstractInsertAreaRepository {
  final AbstractInsertAreaApi _api;
  final Logger _logger = Logger('Insert area repository');

  InsertAreaRepositoryImpl({required AbstractInsertAreaApi api}) : _api = api;

  /*
    Inserts a new Area in the system

    @return A Success if the insert is successful, or a Failure
      containing the errorMessage

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) name.isNotEmpty
  */
  @override
  Future<Result> insertArea({required String name}) async {
    try {
      _logger.finer('Insert area repository: Inserting area into PowerSync '
          'Database start');

      assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
      assert(getIt<SupabaseClient>().auth.currentSession != null);

      await _api.insertArea(name: name);

      _logger.finer('Insert area repository: Inserting area into PowerSync '
          'Database end');

      return const insert_area_result_classes.Success();
    } catch (e) {
      return insert_area_result_classes.Failure(errorMessage: e.toString());
    }
  }
}
