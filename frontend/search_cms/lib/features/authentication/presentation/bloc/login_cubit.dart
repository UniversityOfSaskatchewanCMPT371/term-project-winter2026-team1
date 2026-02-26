import 'package:bloc/bloc.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/authentication/domain/entities/authentication_sign_in_result_classes.dart';
import 'package:search_cms/features/authentication/domain/usecases/authentication_usecases.dart';
import 'login_state.dart';

/*
  State management class for the Login page
  For details of what cubit is,
  please read https://bloclibrary.dev/bloc-concepts/#cubit
 */
class LoginCubit extends Cubit<LoginState> {

  // Constructor
  LoginCubit() : super(const LoginInitial());

  /*
    The sign in function with email and password to Supabase

    @param email A String containing a valid email address
    @param password A String containing a password with a length not shorter than 6
      and not longer than 72

    Preconditions: password.length >= 6 && password.length <= 72
    Postconditions:
    If login is successful, the login page will get a LoginSuccess state,
    and LoginFailure if otherwise
   */
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(const LoginLoading());

    // Assertion for the preconditions
    assert(password.length >= 6 && password.length <= 72);

    try {
      final usecases = getIt<AuthenticationUsecases>();
      final result = await usecases.authenticationSignInUsecase(email, password);

      if (result is Success) {
        emit(LoginSuccess(result.userEntity));
      } else if (result is Failure) {
        emit(LoginFailure(result.errorMessage));
      } else {
        /*
         This will be triggered if the app gets a Result class that is not
         recognized
         */

        emit(const LoginFailure('Unknown authentication result'));
      }
    } catch (e) {
      emit(LoginFailure('Sign in failed: $e'));
    }
  }

  void reset() => emit(const LoginInitial());
}
