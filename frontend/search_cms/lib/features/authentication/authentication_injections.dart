import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/authentication/data/data_sources/authentication_sign_in_api_impl.dart';
import 'package:search_cms/features/authentication/data/repositories/authentication_sign_in_repository_impl.dart';
import 'package:search_cms/features/authentication/domain/usecases/authentication_sign_in_usecase.dart';
import 'package:search_cms/features/authentication/domain/usecases/authentication_usecases.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/*
  This defines how getIt should construct the classes for us

  Postconditions: How these classes would be generated when we call
  getIt<ClassName>() is defined
 */
void initAuthenticationInjections() {
  getIt.registerFactory<AuthenticationSignInApiImpl>(() =>
      AuthenticationSignInApiImpl(supabaseClient: getIt<SupabaseClient>(), powerSyncDatabase: getIt<PowerSyncDatabase>()));

  getIt.registerFactory<AuthenticationSignInRepositoryImpl>(() =>
      AuthenticationSignInRepositoryImpl(api: getIt<AuthenticationSignInApiImpl>()));

  getIt.registerFactory<AuthenticationSignInUsecase>(() =>
      AuthenticationSignInUsecase(repository: getIt<AuthenticationSignInRepositoryImpl>()));

  getIt.registerLazySingleton<AuthenticationUsecases>(() =>
    AuthenticationUsecases(authenticationSignInUsecase: getIt<AuthenticationSignInUsecase>()));
}