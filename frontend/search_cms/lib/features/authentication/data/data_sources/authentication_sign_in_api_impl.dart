import 'dart:async';

import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';
import 'abstract_authentication_sign_in_api.dart';

// The api for signing in with Supabase through email and password
class AuthenticationSignInApiImpl implements AbstractAuthenticationSignInApi {
  // The Supabase client that is passed into this class
  final SupabaseClient _supabaseClient;
  final PowerSyncDatabase _powerSyncDatabase;

  /*
    The logger class we use to do logging.
    The question mark means it can be null.
    The reason is the logger can potentially leak information to hackers,
    so we set the project logging level to OFF so the logger is not constructed.
    The code before will check if logger is built and chooses not to log if
    there is no logger.
   */
  final Logger _logger = Logger('Authentication Sign In Api');

  AuthenticationSignInApiImpl({
    required SupabaseClient supabaseClient,
    required PowerSyncDatabase powerSyncDatabase,
  })  : _supabaseClient = supabaseClient,
        _powerSyncDatabase = powerSyncDatabase;

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
      _logger.finer('Authentication sign in API start');

      // Assertion for the preconditions
      assert(password.length >= 6 && password.length <= 72);

      final AuthResponse authResponse =
      await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _logger.finest(authResponse);

      final Session? session = authResponse.session;
      _logger.finest(session);

      if (session == null) {
        _logger.finer('Authentication sign in API end');
        return null;
      }

      // waitForFirstSync allows you to load the data to PowerSync after login.
      // Keep a bounded wait so the login flow fails cleanly instead of hanging forever.
      await _powerSyncDatabase.waitForFirstSync().timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw TimeoutException('PowerSync sync timed out during login');
        },
      );

      List<Map<String, dynamic>> queryResult = [];

      // Give PowerSync a short window after first sync for the role row to appear.
      for (int i = 0; i < 10; i++) {
        final rawResult = await _powerSyncDatabase.getAll(
          'SELECT * FROM role WHERE user_id = ?',
          [session.user.id],
        );

        queryResult = rawResult
            .map(
              (row) => row.map(
                (key, value) => MapEntry(key, value),
          ),
        )
            .toList();

        _logger.finest(queryResult);

        if (queryResult.length == 1) {
          break;
        }

        await Future<void>.delayed(const Duration(seconds: 1));
      }

      if (queryResult.isEmpty) {
        throw StateError(
          'No synced role row found for user ${session.user.id} using query role.user_id = auth.users.id',
        );
      }

      if (queryResult.length > 1) {
        throw StateError(
          'Multiple synced role rows found for user ${session.user.id}: ${queryResult.length}',
        );
      }

      final dynamic userId = queryResult[0]['user_id'];
      final dynamic role = queryResult[0]['role'];

      if (userId == null) {
        throw StateError(
          'Synced role row is missing user_id for user ${session.user.id}',
        );
      }

      if (userId != session.user.id) {
        throw StateError(
          'Synced role row user_id does not match authenticated user. '
              'Expected ${session.user.id}, got $userId',
        );
      }

      if (role == null) {
        throw StateError(
          'Synced role row is missing role for user ${session.user.id}',
        );
      }

      if (role != 'admin' && role != 'researcher' && role != 'viewer') {
        throw StateError(
          'Unexpected synced role value for user ${session.user.id}: $role',
        );
      }

      final UserModel userModel = UserModel(
        id: session.user.id,
        role: role as String,
      );

      _logger.finer('Authentication sign in API end');
      return userModel;
    } catch (e) {
      _logger.shout(e);
      rethrow;
    }
  }
}