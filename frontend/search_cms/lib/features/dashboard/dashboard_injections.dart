import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/data/data_sources/get_all_areas_api_impl.dart';
import 'package:search_cms/features/dashboard/data/data_sources/get_all_levels_api_impl.dart';
import 'package:search_cms/features/dashboard/data/data_sources/get_all_sites_api_impl.dart';
import 'package:search_cms/features/dashboard/data/data_sources/get_all_units_api_impl.dart';
import 'package:search_cms/features/dashboard/data/data_sources/insert_area_api_impl.dart';
import 'package:search_cms/features/dashboard/data/data_sources/insert_site_api_impl.dart';
import 'package:search_cms/features/dashboard/data/data_sources/insert_site_area_api_impl.dart';
import 'package:search_cms/features/dashboard/data/repositories/get_all_areas_repository_impl.dart';
import 'package:search_cms/features/dashboard/data/repositories/get_all_levels_repository_impl.dart';
import 'package:search_cms/features/dashboard/data/repositories/get_all_sites_repository_impl.dart';
import 'package:search_cms/features/dashboard/data/repositories/get_all_units_repository_impl.dart';
import 'package:search_cms/features/dashboard/data/repositories/insert_area_repository_impl.dart';
import 'package:search_cms/features/dashboard/data/repositories/insert_site_area_repository_impl.dart';
import 'package:search_cms/features/dashboard/data/repositories/insert_site_repository_impl.dart';
import 'package:search_cms/features/dashboard/domain/usecases/dashboard_usecases.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_areas_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_levels_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_sites_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_units_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/insert_area_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/insert_site_area_usecase.dart';
import 'package:search_cms/features/dashboard/domain/usecases/insert_site_usecase.dart';

/*
  This defines how getIt should construct the classes for us

  Postconditions: How these classes would be generated when we call
  getIt<ClassName>() are defined
 */
void initDashboardInjections() {
  _registerGetAllSitesUseCase();
  _registerGetAllAreasUseCase();
  _registerGetAllUnitsUseCase();
  _registerGetAllLevelsUseCase();
  _registerInsertSiteUseCase();
  _registerInsertAreaUseCase();
  _registerInsertSiteAreaUseCase();

  // The dashboard use case collection
  getIt.registerFactory<DashboardUsecases>(
    () => DashboardUsecases(
      getAllSitesUseCase: getIt<GetAllSitesUseCase>(),
      getAllAreasUseCase: getIt<GetAllAreasUseCase>(),
      getAllUnitsUseCase: getIt<GetAllUnitsUseCase>(),
      getAllLevelsUseCase: getIt<GetAllLevelsUseCase>(),
      insertSiteUsecase: getIt<InsertSiteUsecase>(),
      insertAreaUsecase: getIt<InsertAreaUsecase>(),
      insertSiteAreaUsecase: getIt<InsertSiteAreaUsecase>(),
    ),
  );
}

/*
 Register all the necessary dependency injections for the get all levels use
 case
 */
void _registerGetAllLevelsUseCase() {
  // Register the GetAllLevelsApiImpl
  getIt.registerFactory<GetAllLevelsApiImpl>(
    () => GetAllLevelsApiImpl(powerSyncDatabase: getIt<PowerSyncDatabase>()),
  );
  // Register the GetAllLevelsRepositoryImpl
  getIt.registerFactory<GetAllLevelsRepositoryImpl>(
    () => GetAllLevelsRepositoryImpl(api: getIt<GetAllLevelsApiImpl>()),
  );
  // Register the GetAllLevelsUseCase
  getIt.registerFactory<GetAllLevelsUseCase>(
    () => GetAllLevelsUseCase(repository: getIt<GetAllLevelsRepositoryImpl>()),
  );
}

/*
 Register all the necessary dependency injections for the get all units use case
 */
void _registerGetAllUnitsUseCase() {
  // Register the GetAllUnitsApiImpl
  getIt.registerFactory<GetAllUnitsApiImpl>(
    () => GetAllUnitsApiImpl(powerSyncDatabase: getIt<PowerSyncDatabase>()),
  );
  // Register the GetAllUnitsRepositoryImpl
  getIt.registerFactory<GetAllUnitsRepositoryImpl>(
    () => GetAllUnitsRepositoryImpl(api: getIt<GetAllUnitsApiImpl>()),
  );
  // Register the GetAllUnitsUseCase
  getIt.registerFactory<GetAllUnitsUseCase>(
    () => GetAllUnitsUseCase(repository: getIt<GetAllUnitsRepositoryImpl>()),
  );
}

/*
 Register all the necessary dependency injections for the get all areas use case
 */
void _registerGetAllAreasUseCase() {
  // Register the GetAllAreasApiImpl
  getIt.registerFactory<GetAllAreasApiImpl>(
    () => GetAllAreasApiImpl(powerSyncDatabase: getIt<PowerSyncDatabase>()),
  );

  // Register the GetAllAreasRepositoryImpl
  getIt.registerFactory<GetAllAreasRepositoryImpl>(
    () => GetAllAreasRepositoryImpl(api: getIt<GetAllAreasApiImpl>()),
  );

  // Register the GetAllAreasUseCase
  getIt.registerFactory<GetAllAreasUseCase>(
    () => GetAllAreasUseCase(repository: getIt<GetAllAreasRepositoryImpl>()),
  );
}

/*
 Register all the necessary dependency injections for the insert site use case
 */
void _registerInsertSiteUseCase() {
  // Register the InsertSiteApiImpl
  getIt.registerFactory<InsertSiteApiImpl>(
    () => InsertSiteApiImpl(powerSyncDatabase: getIt<PowerSyncDatabase>()),
  );
  // Register the InsertSiteRepositoryImpl
  getIt.registerFactory<InsertSiteRepositoryImpl>(
    () => InsertSiteRepositoryImpl(api: getIt<InsertSiteApiImpl>()),
  );
  // Register the InsertSiteUsecase
  getIt.registerFactory<InsertSiteUsecase>(
    () => InsertSiteUsecase(repository: getIt<InsertSiteRepositoryImpl>()),
  );
}

/*
 Register all the necessary dependency injections for the insert area use case
 */
void _registerInsertAreaUseCase() {
  // Register the InsertAreaApiImpl
  getIt.registerFactory<InsertAreaApiImpl>(
    () => InsertAreaApiImpl(powerSyncDatabase: getIt<PowerSyncDatabase>()),
  );
  // Register the InsertAreaRepositoryImpl
  getIt.registerFactory<InsertAreaRepositoryImpl>(
    () => InsertAreaRepositoryImpl(api: getIt<InsertAreaApiImpl>()),
  );
  // Register the InsertAreaUsecase
  getIt.registerFactory<InsertAreaUsecase>(
    () => InsertAreaUsecase(repository: getIt<InsertAreaRepositoryImpl>()),
  );
}

/*
 Register all the necessary dependency injections for the insert site_area use case
 */
void _registerInsertSiteAreaUseCase() {
  // Register the InsertSiteAreaApiImpl
  getIt.registerFactory<InsertSiteAreaApiImpl>(
    () => InsertSiteAreaApiImpl(powerSyncDatabase: getIt<PowerSyncDatabase>()),
  );
  // Register the InsertSiteAreaRepositoryImpl
  getIt.registerFactory<InsertSiteAreaRepositoryImpl>(
    () => InsertSiteAreaRepositoryImpl(api: getIt<InsertSiteAreaApiImpl>()),
  );
  // Register the InsertSiteAreaUsecase
  getIt.registerFactory<InsertSiteAreaUsecase>(
    () => InsertSiteAreaUsecase(repository: getIt<InsertSiteAreaRepositoryImpl>()),
  );
}

/*
 Register all the necessary dependency injections for the get all sites use case
 */
void _registerGetAllSitesUseCase() {
  // Register the GetAllSitesApiImpl
  getIt.registerFactory<GetAllSitesApiImpl>(
    () => GetAllSitesApiImpl(powerSyncDatabase: getIt<PowerSyncDatabase>()),
  );

  // Register the GetAllSitesRepositoryImpl
  getIt.registerFactory<GetAllSitesRepositoryImpl>(
    () => GetAllSitesRepositoryImpl(api: getIt<GetAllSitesApiImpl>()),
  );

  // Register the GetAllSitesUseCase
  getIt.registerFactory<GetAllSitesUseCase>(
    () => GetAllSitesUseCase(repository: getIt<GetAllSitesRepositoryImpl>()),
  );

  // The dashboard use case collection
  getIt.registerFactory<DashboardUsecases>(
    () => DashboardUsecases(getAllSitesUseCase: getIt<GetAllSitesUseCase>()),
  );
}
