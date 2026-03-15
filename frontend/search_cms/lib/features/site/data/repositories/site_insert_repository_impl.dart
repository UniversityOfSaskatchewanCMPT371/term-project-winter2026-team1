import 'package:logging/logging.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/site/data/data_sources/abstract_site_insert_api.dart';
import 'package:search_cms/features/site/data/models/site_model.dart';
import 'package:search_cms/features/site/domain/entities/site_entity.dart';

import '../../../../core/utils/class_templates/result.dart';
import '../../domain/entities/site_insert_result_classes.dart'
    as site_insert_result_classes;
import '../../domain/repositories/abstract_site_insert_repository.dart';

/*
  The repository implementation for inserting a new site into Supabase
 */
class SiteInsertRepositoryImpl implements AbstractSiteInsertRepository {
  /*
    This is the interface for the api for site insert. We will pass in the
    actual implementation for the api here.
   */
  final AbstractSiteInsertApi _api;
  final Logger? _logger = logLevel != Level.OFF
      ? Logger('Site Insert Repository')
      : null;

  SiteInsertRepositoryImpl({required AbstractSiteInsertApi api}) : _api = api;

  /*
    The repository function for inserting a new site into Supabase

    @param name A String containing the name of the site. Can be empty.
    @param borden A String containing the Borden classification code.
      Max 8 characters and must be unique.
    @return A Success if insert is successful, containing the SiteEntity or
      Failure containing the errorMessage otherwise

    Preconditions: borden.length <= 8 && borden.isNotEmpty
    Postconditions: A Result children class Success or Failure will be returned
  */
  @override
  Future<Result> insertSite(String name, String borden) async {
    try {
      _logger?.finer('Site insert repository start');

      // Assertion for the preconditions
      assert(borden.isNotEmpty && borden.length <= 8);

      SiteModel? siteModel = await _api.insertSite(name, borden);

      if (siteModel != null) {
        return site_insert_result_classes.Success(
          siteEntity: SiteEntity(
            id: siteModel.id,
            name: siteModel.name,
            borden: siteModel.borden,
          ),
        );
      } else {
        return site_insert_result_classes.Failure(
          errorMessage: 'Site insert failed',
        );
      }
    } catch (e) {
      return site_insert_result_classes.Failure(
        errorMessage: e.toString(),
      );
    }
  }
}
