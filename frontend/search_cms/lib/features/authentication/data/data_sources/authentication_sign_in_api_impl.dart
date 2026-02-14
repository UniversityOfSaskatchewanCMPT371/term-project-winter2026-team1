import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/constants.dart';
import '../models/user_model.dart';
import 'abstract_authentication_sign_in_api.dart';

// The api for signing in with Supabase through email and password
class AuthenticationSignInApiImpl implements AbstractAuthenticationSignInApi {

  final Logger? logger =
      logLevel != Level.OFF ? Logger('Authentication Sign In Api') : null;

  /*
    The api function for signing in with Supabase through email and password
   */
  @override
  Future<UserModel?> signIn(String email, String password) async {
    try {
      logger?.finer('Authentication sign in API start');

      // Assertion for the preconditions
      assert(password.length >= 6 && password.length <= 72);

      final AuthResponse authResponse =
        await Supabase.instance.client.auth.signInWithPassword(
          email: email,
          password: password,
      );
      logger?.finest(authResponse);

      final Session? session = authResponse.session;
      logger?.finest(session);

      if (session != null) {
        PostgrestList queryResult = await Supabase.instance.client.
          from('role').select().eq('id', session.user.id);

        logger?.finest(queryResult);

        assert(queryResult.length == 1);
        assert(queryResult[0]['id'] != null);
        assert(queryResult[0]['role'] != null);
        assert(queryResult[0]['role'] == 'admin' ||
            queryResult[0]['role'] == 'researcher' ||
            queryResult[0]['role'] == 'viewer'
        );

        UserModel userModel = UserModel(
          id: queryResult[0]['id'],
          role: queryResult[0]['role']
        );

        logger?.finer('Authentication sign in API end');

        return userModel;
      } else {
        logger?.finer('Authentication sign in API end');

        return null;
      }
    } catch (e) {
      logger?.shout(e);

      rethrow;
    }
  }
}