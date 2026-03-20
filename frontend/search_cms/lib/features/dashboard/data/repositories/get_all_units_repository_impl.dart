import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/class_templates/result.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/get_all_units_result_classes.dart'
    as get_all_units_result_classes;
import '../../domain/entities/unit_entity.dart';
import '../../domain/repositories/abstract_get_all_units_repository.dart';
import '../data_sources/abstract_get_all_units_api.dart';
import '../models/unit_model.dart';

/*
  The repository implementation for retrieving all units
 */
class GetAllUnitsRepositoryImpl implements AbstractGetAllUnitsRepository {
  // The api instance
  final AbstractGetAllUnitsApi _api;
  final Logger _logger = Logger('Get all areas repository');

  GetAllUnitsRepositoryImpl({required AbstractGetAllUnitsApi api}) : _api = api;

  /*
    Retrieves all Units in the system

    @return A list containing all UnitEntity objects currently stored
      if no units exist an empty list is returned

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  @override
  Future<Result> getAllUnits() async {
    try {
      _logger.finer(
        'Get all units repository: Retrieving all units from '
        'PowerSync Database start',
      );

      /*
       Check if the PowerSync database has error, if not, we see it as
       initialized.
       */
      assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
      // Check if the user is authenticated
      assert(getIt<SupabaseClient>().auth.currentSession != null);

      // Call the api to get the unit models
      List<UnitModel> listOfUnitModel = await _api.getAllUnits();

      List<UnitEntity> listOfUnitEntity = [];

      for (UnitModel unitModel in listOfUnitModel) {
        UnitEntity unitEntity = unitModel.toEntity();
        listOfUnitEntity.add(unitEntity);
      }

      _logger.finer(
        'Get all units repository: Retrieving all units from '
        'PowerSync Database end',
      );

      return get_all_units_result_classes.Success(
        listOfUnitEntity: listOfUnitEntity,
      );
    } catch (e) {
      // If the fetch is not successful, return Failure with the error message
      return get_all_units_result_classes.Failure(errorMessage: e.toString());
    }
  }
}
