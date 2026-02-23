import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/constants.dart';
import '../models/user_model.dart';
import 'abstract_authentication_sign_in_api.dart';

// The api for signing in with Supabase through email and password
class AuthenticationSignInApiImpl implements AbstractAuthenticationSignInApi {

  // The Supabase client that is passed into this class
  final SupabaseClient _supabaseClient;

  /*
    The logger class we use to do logging.
    The question mark means it can be null.
    The reason is the logger can potentially leak information to hackers,
    so we set the project logging level to OFF so the logger is not constructed.
    The code before will check if logger is built and chooses not to log if
    there is no logger.
   */
  final Logger? _logger =
      logLevel != Level.OFF ? Logger('Authentication Sign In Api') : null;

  AuthenticationSignInApiImpl({required SupabaseClient supabaseClient}) : _supabaseClient = supabaseClient;

  /*
    The api function for signing in with email and password to Supabase

    @param email A String containing a valid email address
    @param password A String containing a password with a length not shorter than 6
      and not longer than 72
    @return A UserModel instance if login is successful or null otherwise

    Preconditions: password.length >= 6 && password.length <= 72
   */
  @override
  Future<UserModel?> signIn(String email, String password) async {
    try {
      _logger?.finer('Authentication sign in API start');

      // Assertion for the preconditions
      assert(password.length >= 6 && password.length <= 72);

      final AuthResponse authResponse =
        await _supabaseClient.auth.signInWithPassword(
          email: email,
          password: password,
      );
      _logger?.finest(authResponse);

      final Session? session = authResponse.session;
      _logger?.finest(session);

      if (session != null) {
        PostgrestList queryResult = await _supabaseClient.
          from('role').select().eq('id', session.user.id);

        _logger?.finest(queryResult);

        // There should be only one role result for one user
        assert(queryResult.length == 1);

        // Id shouldn't be null
        assert(queryResult[0]['id'] != null);

        // Role shouldn't be null
        assert(queryResult[0]['role'] != null);

        // The role should be a string that is admin or researcher or viewer
        assert(queryResult[0]['role'] == 'admin' ||
            queryResult[0]['role'] == 'researcher' ||
            queryResult[0]['role'] == 'viewer'
        );

        UserModel userModel = UserModel(
          id: queryResult[0]['id'],
          role: queryResult[0]['role']
        );

        _logger?.finer('Authentication sign in API end');

        return userModel;
      } else {
        _logger?.finer('Authentication sign in API end');

        return null;
      }
    } catch (e) {
      _logger?.shout(e);

      rethrow;
    }
  }
}