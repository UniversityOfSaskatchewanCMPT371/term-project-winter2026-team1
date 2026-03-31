import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/class_templates/result.dart';
import '../../domain/entities/insert_assemblage_result_classes.dart'
    as insert_assemblage_result_classes;
import '../../domain/repositories/abstract_insert_assemblage_repository.dart';
import '../data_sources/abstract_insert_assemblage_api.dart';

/*
  The repository implementation for inserting an assemblage
*/
class InsertAssemblageRepositoryImpl implements AbstractInsertAssemblageRepository {
  final AbstractInsertAssemblageApi _api;
  final Logger _logger = Logger('Insert assemgblage repository');

  InsertAssemblageRepositoryImpl({required AbstractInsertAssemblageApi api}) : _api = api;

  /*
    Inserts a new assemblage in the system

    @return A Success if the insert is successful, or a Failure
      containing the errorMessage

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
      (3) unitName.isNotEmpty && levelName.isNotEmpty
  */
  @override
  Future<Result> insertAssemblage({String? name, required String unitName, required String levelName }) async {
    try {
      _logger.finer('Insert unit repository: Inserting assemblage into PowerSync '
          'Database start');

      assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
      assert(getIt<SupabaseClient>().auth.currentSession != null);

      await _api.insertAssemblage(name: name, unitName: unitName, levelName: levelName);

      _logger.finer('Insert assemblage repository: Inserting assemblage into PowerSync '
          'Database end');

      return const insert_assemblage_result_classes.Success();
    } catch (e) {
      return insert_assemblage_result_classes.Failure(errorMessage: e.toString());
    }
  }
}
