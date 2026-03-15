import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/area/data/data_sources/area_insert_api_impl.dart';
import 'package:search_cms/features/area/data/repositories/area_insert_repository_impl.dart';
import 'package:search_cms/features/area/domain/usecases/area_insert_usecase.dart';
import 'package:search_cms/features/area/domain/usecases/area_usecases.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/*
  This defines how getIt should construct the classes for the area feature.

  Postconditions: How these classes would be generated when we call
  getIt<ClassName>() is defined
 */
void initAreaInjections() {
  getIt.registerFactory<AreaInsertApiImpl>(() =>
      AreaInsertApiImpl(supabaseClient: getIt<SupabaseClient>()));

  getIt.registerFactory<AreaInsertRepositoryImpl>(() =>
      AreaInsertRepositoryImpl(api: getIt<AreaInsertApiImpl>()));

  getIt.registerFactory<AreaInsertUsecase>(() =>
      AreaInsertUsecase(repository: getIt<AreaInsertRepositoryImpl>()));

  getIt.registerLazySingleton<AreaUsecases>(() =>
      AreaUsecases(areaInsertUsecase: getIt<AreaInsertUsecase>()));
}
