import '../../../../core/utils/class_templates/result.dart';
import '../repositories/abstract_authentication_sign_in_repository.dart';


class AuthenticationSignInUsecase {
  final AbstractAuthenticationSignInRepository repository;

  AuthenticationSignInUsecase({required this.repository});

  /*
    The use case for signing in with email and password to Suapabase

    @param email A String containing a valid email address
    @param password A String containing a password with a length not shorter than 6
      and not longer than 72
    @return A Success if login is successful, containing the UserEntity or
      Failure containing the errorMessage otherwise

    Preconditions: password.length >= 6 && password.length <= 72
   */
  Future<Result> call(String email, String password) async {
    // Assertion for the preconditions
    assert(password.length >= 6 && password.length <= 72);

    Result result = await repository.signIn(email, password);
    return result;
  }
}