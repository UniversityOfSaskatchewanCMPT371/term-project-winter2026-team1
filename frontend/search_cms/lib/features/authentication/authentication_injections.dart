import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/authentication/data/data_sources/authentication_sign_in_api_impl.dart';
import 'package:search_cms/features/authentication/data/repositories/authentication_sign_in_repository_impl.dart';
import 'package:search_cms/features/authentication/domain/usecases/authentication_sign_in_usecase.dart';
import 'package:search_cms/features/authentication/domain/usecases/authentication_usecases.dart';

void initAuthenticationInjections() {
  getIt.registerFactory<AuthenticationSignInRepositoryImpl>(() =>
      AuthenticationSignInRepositoryImpl(api: getIt<AuthenticationSignInApiImpl>()));
  getIt.registerFactory<AuthenticationSignInUsecase>(() =>
      AuthenticationSignInUsecase(repository: getIt<AuthenticationSignInRepositoryImpl>()));
  getIt.registerFactory<AuthenticationUsecases>(() =>
    AuthenticationUsecases(authenticationSignInUsecase: getIt<AuthenticationSignInUsecase>()));
}