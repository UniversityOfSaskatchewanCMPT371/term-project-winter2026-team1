import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/site/data/data_sources/site_insert_api_impl.dart';
import 'package:search_cms/features/site/data/repositories/site_insert_repository_impl.dart';
import 'package:search_cms/features/site/domain/usecases/site_insert_usecase.dart';
import 'package:search_cms/features/site/domain/usecases/site_usecases.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/*
  This defines how getIt should construct the classes for the site feature.

  Postconditions: How these classes would be generated when we call
  getIt<ClassName>() is defined
 */
void initSiteInjections() {
  getIt.registerFactory<SiteInsertApiImpl>(() =>
      SiteInsertApiImpl(supabaseClient: getIt<SupabaseClient>()));

  getIt.registerFactory<SiteInsertRepositoryImpl>(() =>
      SiteInsertRepositoryImpl(api: getIt<SiteInsertApiImpl>()));

  getIt.registerFactory<SiteInsertUsecase>(() =>
      SiteInsertUsecase(repository: getIt<SiteInsertRepositoryImpl>()));

  getIt.registerLazySingleton<SiteUsecases>(() =>
      SiteUsecases(siteInsertUsecase: getIt<SiteInsertUsecase>()));
}
