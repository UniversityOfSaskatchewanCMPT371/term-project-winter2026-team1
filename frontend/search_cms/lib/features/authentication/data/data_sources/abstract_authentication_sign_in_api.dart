import 'package:search_cms/features/authentication/data/models/user_model.dart';

abstract class AbstractAuthenticationSignInApi {

  /*
    The api function for signing in with email and password to Suapabase

    @param email A String containing a valid email address
    @param password A String containing a password with a length not shorter than 6
      and not longer than 72
    @return A UserModel instance if login is successful or null otherwise

    Preconditions: password.length >= 6 && password.length <= 72
   */
  Future<UserModel?> signIn(String email, String password);
}