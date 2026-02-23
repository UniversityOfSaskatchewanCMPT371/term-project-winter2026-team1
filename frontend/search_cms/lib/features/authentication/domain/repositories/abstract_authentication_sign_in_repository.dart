import '../../../../core/utils/class_templates/result.dart';

abstract class AbstractAuthenticationSignInRepository {
  /*
    The repository function for signing in with email and password to Supabase

    @param email A String containing a valid email address
    @param password A String containing a password with a length not shorter than 6
      and not longer than 72
    @return A Success if login is successful, containing the UserEntity or
      Failure containing the errorMessage otherwise

    Preconditions: password.length >= 6 && password.length <= 72
    Postconditions: A Result children class Success or Failure will be returned
   */
  Future<Result> signIn(String email, String password);
}