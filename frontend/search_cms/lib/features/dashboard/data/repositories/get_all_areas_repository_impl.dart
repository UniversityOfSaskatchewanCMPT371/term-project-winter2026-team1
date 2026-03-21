import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/class_templates/result.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/area_entity.dart';
import '../../domain/entities/get_all_areas_result_classes.dart'
  as get_all_areas_result_classes;
import '../../domain/repositories/abstract_get_all_areas_repository.dart';
import '../data_sources/abstract_get_all_areas_api.dart';
import '../models/area_model.dart';

/*
  The repository implementation for retrieving all areas
 */
class GetAllAreasRepositoryImpl implements AbstractGetAllAreasRepository {
  // The api instance for retrieving all areas
  final AbstractGetAllAreasApi _api;
  final Logger _logger = Logger('Get all areas repository');

  GetAllAreasRepositoryImpl({required AbstractGetAllAreasApi api}) : _api = api;

  /*
    Retrieves all Areas in the system

    @return A Success if the fetch is successful, containing the list of area
      entities or Failure containing the errorMessage otherwise

    Preconditions:
      (1) PowerSync database is initialized
      (2) The user must be authenticated
  */
  @override
  Future<Result> getAllAreas() async {
    try {
      _logger.finer(
        'Get all areas repository: Retrieving all areas from '
        'PowerSync Database start',
      );

      /*
       Check if the PowerSync database has error, if not, we see it as
       initialized.
       */
      assert(getIt<PowerSyncDatabase>().currentStatus.anyError == null);
      // Check if the user is authenticated
      assert(getIt<SupabaseClient>().auth.currentSession != null);

      // Call the api to get the area models
      List<AreaModel> listOfAreaModel = await _api.getAllAreas();

      List<AreaEntity> listOfAreaEntity = [];

      for (AreaModel areaModel in listOfAreaModel) {
        AreaEntity areaEntity = areaModel.toEntity();
        listOfAreaEntity.add(areaEntity);
      }

      _logger.finer(
        'Get all areas repository: Retrieving all areas from '
        'PowerSync Database end',
      );

      return get_all_areas_result_classes.Success(
        listOfAreaEntity: listOfAreaEntity,
      );
    } catch (e) {
      // If the fetch is not successful, return Failure with the error message
      return get_all_areas_result_classes.Failure(errorMessage: e.toString());
    }
  }
}
