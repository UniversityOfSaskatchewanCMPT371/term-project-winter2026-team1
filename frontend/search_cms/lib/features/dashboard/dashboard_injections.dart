import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/data/data_sources/get_all_sites_api_impl.dart';
import 'package:search_cms/features/dashboard/data/repositories/get_all_sites_repository_impl.dart';
import 'package:search_cms/features/dashboard/domain/usecases/dashboard_usecases.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_sites_usecase.dart';

/*
  This defines how getIt should construct the classes for us

  Postconditions: How these classes would be generated when we call
  getIt<ClassName>() are defined
 */
void initDashboardInjections() {
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
