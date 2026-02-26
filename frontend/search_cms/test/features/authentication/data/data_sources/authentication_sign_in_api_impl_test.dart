/// Unit tests for AuthenticationSignInApiImpl.
///
/// Confirms API layer:
/// - authenticates via auth.signInWithPassword
/// - fetches role from `role` table
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search_cms/features/authentication/data/data_sources/authentication_sign_in_api_impl.dart';
import 'package:search_cms/features/authentication/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../mocks/authentication_mocks.mocks.dart';

/// A Future-like PostgrestFilterBuilder fake
class RoleFilterBuilderFake extends Fake
    implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {
  RoleFilterBuilderFake(this.rows);

  final List<Map<String, dynamic>> rows;

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> eq(
      String column,
      Object value, {
        bool? ascending,
        bool? nullsFirst,
      }) {
    return this;
  }

  @override
  Future<R> then<R>(
      FutureOr<R> Function(List<Map<String, dynamic>> value) onValue, {
        Function? onError,
      }) {
    return Future<R>.value(onValue(rows));
  }
}

void main() {
  group('AuthenticationSignInApiImpl', () {
    test('DATA-SOURCE-1-returns UserModel when session exists and role query is valid', () async {
      final client = MockSupabaseClient();
      final auth = MockGoTrueClient();
      final authResponse = MockAuthResponse();
      final session = MockSession();
      final user = MockUser();

      final queryBuilder = MockSupabaseQueryBuilder();

      when(client.auth).thenAnswer((_) => auth);

      when(auth.signInWithPassword(email: 'abc@abc.com', password: '123456'))
          .thenAnswer((_) async => authResponse);

      when(authResponse.session).thenAnswer((_) => session);
      when(session.user).thenAnswer((_) => user);
      when(user.id).thenAnswer((_) => 'u1');

      final roleRows = <Map<String, dynamic>>[
        {'id': 'u1', 'role': 'viewer'},
      ];
      final roleFilter = RoleFilterBuilderFake(roleRows);

      when(client.from('role')).thenAnswer((_) => queryBuilder);
      when(queryBuilder.select(any)).thenAnswer((_) => roleFilter);

      final api = AuthenticationSignInApiImpl(supabaseClient: client);

      final UserModel? result = await api.signIn('abc@abc.com', '123456');

      expect(result, isNotNull);
      expect(result!.id, 'u1');
      expect(result.role, 'viewer');

      verify(auth.signInWithPassword(email: 'abc@abc.com', password: '123456')).called(1);
      verify(client.from('role')).called(1);
      verify(queryBuilder.select(any)).called(1);
    });

    test('DATA-SOURCE-2-returns null when session is null', () async {
      final client = MockSupabaseClient();
      final auth = MockGoTrueClient();
      final authResponse = MockAuthResponse();

      when(client.auth).thenAnswer((_) => auth);
      when(auth.signInWithPassword(email: 'abc@abc.com', password: '123456'))
          .thenAnswer((_) async => authResponse);

      when(authResponse.session).thenAnswer((_) => null);

      final api = AuthenticationSignInApiImpl(supabaseClient: client);

      final result = await api.signIn('abc@abc.com', '123456');

      expect(result, isNull);
      verify(auth.signInWithPassword(email: 'abc@abc.com', password: '123456')).called(1);
      verifyNever(client.from(any));
    });

    test('DATA-SOURCE-3-rethrows when Supabase throws', () async {
      final client = MockSupabaseClient();
      final auth = MockGoTrueClient();

      when(client.auth).thenAnswer((_) => auth);
      when(auth.signInWithPassword(email: 'abc@abc.com', password: '123456'))
          .thenThrow(Exception('boom'));

      final api = AuthenticationSignInApiImpl(supabaseClient: client);

      expect(
            () => api.signIn('abc@abc.com', '123456'),
        throwsA(isA<Exception>()),
      );
    });

    test('DATA-SOURCE-4-asserts when password length is invalid', () async {
      final client = MockSupabaseClient();
      final api = AuthenticationSignInApiImpl(supabaseClient: client);

      expect(
            () => api.signIn('abc@abc.com', '12345'),
        throwsA(isA<AssertionError>()),
      );

      expect(
            () => api.signIn('abc@abc.com', 'x' * 73),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}