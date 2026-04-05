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

      List<Map<String, dynamic>> queryResult = [];

      try {
        await _powerSyncDatabase.waitForFirstSync().timeout(
          const Duration(seconds: 60),
          onTimeout: () {
            throw TimeoutException('PowerSync sync timed out during login');
          },
        );

        for (int i = 0; i < 10; i++) {
          final rawResult = await _powerSyncDatabase.getAll(
            'SELECT * FROM role WHERE id = ?',
            [session.user.id],
          );

          queryResult = rawResult
              .map((row) => row.map((key, value) => MapEntry(key, value)))
              .toList();

          _logger.finest(queryResult);

          if (queryResult.length == 1) {
            break;
          }

          await Future<void>.delayed(const Duration(seconds: 1));
        }
      } on TimeoutException catch (e) {
        _logger.warning(
          'PowerSync sync timed out during login, falling back to Supabase role query: $e',
        );
      }

      if (queryResult.isEmpty) {
        final fallbackResult = await _supabaseClient
            .from('role')
            .select('id, role')
            .eq('id', session.user.id);

        queryResult = List<Map<String, dynamic>>.from(fallbackResult);
        _logger.finest('Fallback Supabase role query result: $queryResult');
      }

      if (queryResult.isEmpty) {
        throw StateError(
          'No role row found for user ${session.user.id} in PowerSync or Supabase',
        );
      }

      if (queryResult.length > 1) {
        throw StateError(
          'Multiple role rows found for user ${session.user.id}: ${queryResult.length}',
        );
      }

      final dynamic rowId = queryResult[0]['id'];
      final dynamic role = queryResult[0]['role'];

      if (rowId == null) {
        throw StateError(
          'Role row is missing id for user ${session.user.id}',
        );
      }

      if (rowId != session.user.id) {
        throw StateError(
          'Role row id does not match authenticated user. Expected ${session.user.id}, got $rowId',
        );
      }

      if (role == null) {
        throw StateError(
          'Role row is missing role for user ${session.user.id}',
        );
      }

      if (role != 'admin' && role != 'researcher' && role != 'viewer') {
        throw StateError(
          'Unexpected role value for user ${session.user.id}: $role',
        );
      }

      final userModel = UserModel(
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