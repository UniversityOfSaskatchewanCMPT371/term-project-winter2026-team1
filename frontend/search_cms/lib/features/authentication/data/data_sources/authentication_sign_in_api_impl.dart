import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import 'abstract_authentication_sign_in_api.dart';

class AuthenticationSignInApiImpl implements AbstractAuthenticationSignInApi {
  @override
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final AuthResponse authResponse = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final Session? session = authResponse.session;

      if (session != null) {
        PostgrestList queryResult = await Supabase.instance.client.
          from('role').select().eq('id', session.user.id);

        if (queryResult.length > 1) {
          throw Exception('Critical error: Returned user more than 1.');
        }

        UserModel userModel = UserModel(
          id: queryResult[0]['id'],
          role: queryResult[0]['role']
        );

        return userModel;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}