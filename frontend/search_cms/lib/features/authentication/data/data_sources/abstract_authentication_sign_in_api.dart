import 'package:search_cms/features/authentication/data/models/user_model.dart';

abstract class AbstractAuthenticationSignInApi {
  Future<UserModel?> signIn(String email, String password);
}