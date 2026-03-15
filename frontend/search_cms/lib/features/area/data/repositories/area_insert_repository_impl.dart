import 'package:logging/logging.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/area/data/data_sources/abstract_area_insert_api.dart';
import 'package:search_cms/features/area/data/models/area_model.dart';
import 'package:search_cms/features/area/domain/entities/area_entity.dart';

import '../../../../core/utils/class_templates/result.dart';
import '../../domain/entities/area_insert_result_classes.dart'
    as area_insert_result_classes;
import '../../domain/repositories/abstract_area_insert_repository.dart';

/*
  The repository implementation for inserting a new area into Supabase
 */
class AreaInsertRepositoryImpl implements AbstractAreaInsertRepository {
  /*
    This is the interface for the api for area insert. We will pass in the
    actual implementation for the api here.
   */
  final AbstractAreaInsertApi _api;
  final Logger? _logger = logLevel != Level.OFF
      ? Logger('Area Insert Repository')
      : null;

  AreaInsertRepositoryImpl({required AbstractAreaInsertApi api}) : _api = api;

  /*
    The repository function for inserting a new area into Supabase

    @param name A String containing the name of the area. Must not be empty.
    @return A Success if insert is successful, containing the AreaEntity or
      Failure containing the errorMessage otherwise

    Preconditions: name.isNotEmpty
    Postconditions: A Result children class Success or Failure will be returned
  */
  @override
  Future<Result> insertArea(String name) async {
    try {
      _logger?.finer('Area insert repository start');

      // Assertion for the preconditions
      assert(name.isNotEmpty);

      AreaModel? areaModel = await _api.insertArea(name);

      if (areaModel != null) {
        return area_insert_result_classes.Success(
          areaEntity: AreaEntity(
            id: areaModel.id,
            name: areaModel.name,
          ),
        );
      } else {
        return area_insert_result_classes.Failure(
          errorMessage: 'Area insert failed',
        );
      }
    } catch (e) {
      return area_insert_result_classes.Failure(
        errorMessage: e.toString(),
      );
    }
  }
}
