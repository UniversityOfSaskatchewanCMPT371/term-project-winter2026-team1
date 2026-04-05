/* Unit tests for AuthenticationSignInApiImpl.

Confirms API layer:
- authenticates via auth.signInWithPassword
- waits for first PowerSync sync
- fetches role from PowerSync
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search_cms/features/authentication/data/data_sources/authentication_sign_in_api_impl.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../mocks/authentication_mocks.mocks.dart';

ResultSet buildRoleResultSet({
  required String userId,
  required String role,
}) {
  final db = sqlite3.openInMemory();
  db.execute('CREATE TABLE role (user_id TEXT, role TEXT);');
  db.execute(
    'INSERT INTO role (user_id, role) VALUES (?, ?);',
    [userId, role],
  );
  return db.select('SELECT * FROM role;');
}

ResultSet buildEmptyResultSet() {
  final db = sqlite3.openInMemory();
  db.execute('CREATE TABLE role (user_id TEXT, role TEXT);');
  return db.select('SELECT * FROM role;');
}

void main() {
  group('AuthenticationSignInApiImpl', () {
    late MockSupabaseClient client;
    late MockGoTrueClient auth;
    late MockPowerSyncDatabase powerSyncDatabase;
    late MockAuthResponse authResponse;

    setUpAll(() {
      provideDummy<ResultSet>(buildEmptyResultSet());
    });

    setUp(() {
      client = MockSupabaseClient();
      auth = MockGoTrueClient();
      powerSyncDatabase = MockPowerSyncDatabase();
      authResponse = MockAuthResponse();

      when(client.auth).thenReturn(auth);
    });

    test('DATA-SOURCE-1-returns UserModel when session exists and role query is valid', () async {
      final session = MockSession();
      final user = MockUser();

      when(auth.signInWithPassword(
        email: 'abc@abc.com',
        password: '123456',
      )).thenAnswer((_) async => authResponse);

      when(authResponse.session).thenReturn(session);
      when(session.user).thenReturn(user);
      when(user.id).thenReturn('u1');

      when(powerSyncDatabase.waitForFirstSync()).thenAnswer((_) async {});

      when(powerSyncDatabase.getAll(
        'SELECT * FROM role WHERE user_id = ?',
        ['u1'],
      )).thenAnswer(
            (_) async => buildRoleResultSet(userId: 'u1', role: 'viewer'),
      );

      final api = AuthenticationSignInApiImpl(
        supabaseClient: client,
        powerSyncDatabase: powerSyncDatabase,
      );

      final result = await api.signIn('abc@abc.com', '123456');

      expect(result, isNotNull);
      expect(result!.id, 'u1');
      expect(result.role, 'viewer');

      verify(auth.signInWithPassword(
        email: 'abc@abc.com',
        password: '123456',
      )).called(1);

      verify(powerSyncDatabase.waitForFirstSync()).called(1);
      verify(powerSyncDatabase.getAll(
        'SELECT * FROM role WHERE user_id = ?',
        ['u1'],
      )).called(1);
    });

    test('DATA-SOURCE-2-returns null when session is null', () async {
      when(auth.signInWithPassword(
        email: 'abc@abc.com',
        password: '123456',
      )).thenAnswer((_) async => authResponse);

      when(authResponse.session).thenReturn(null);

      final api = AuthenticationSignInApiImpl(
        supabaseClient: client,
        powerSyncDatabase: powerSyncDatabase,
      );

      final result = await api.signIn('abc@abc.com', '123456');

      expect(result, isNull);

      verify(auth.signInWithPassword(
        email: 'abc@abc.com',
        password: '123456',
      )).called(1);

      verifyNever(powerSyncDatabase.waitForFirstSync());
      verifyNever(powerSyncDatabase.getAll(
        'SELECT * FROM role WHERE user_id = ?',
        ['u1'],
      ));
    });

    test('DATA-SOURCE-3-rethrows when Supabase throws', () async {
      when(auth.signInWithPassword(
        email: 'abc@abc.com',
        password: '123456',
      )).thenThrow(Exception('boom'));

      final api = AuthenticationSignInApiImpl(
        supabaseClient: client,
        powerSyncDatabase: powerSyncDatabase,
      );

      expect(
            () => api.signIn('abc@abc.com', '123456'),
        throwsA(isA<Exception>()),
      );
    });

    test('DATA-SOURCE-4-asserts when password length is invalid', () {
      final api = AuthenticationSignInApiImpl(
        supabaseClient: client,
        powerSyncDatabase: powerSyncDatabase,
      );

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