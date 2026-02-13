import 'package:bloc/bloc.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/authentication/domain/entities/authentication_sign_in_result_classes.dart';
import 'package:search_cms/features/authentication/domain/usecases/authentication_usecases.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginInitial());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(const LoginLoading());

    try {
      final usecases = getIt<AuthenticationUsecases>();
      final result = await usecases.authenticationSignInUsecase(email, password);

      if (result is Success) {
        emit(LoginSuccess(result.userEntity));
      } else if (result is Failure) {
        emit(LoginFailure(result.errorMessage));
      } else {
        emit(const LoginFailure('Unknown authentication result'));
      }
    } catch (e) {
      emit(LoginFailure('Sign in failed: $e'));
    }
  }

  void reset() => emit(const LoginInitial());
}
