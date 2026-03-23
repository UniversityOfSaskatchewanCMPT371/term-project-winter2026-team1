// PowerSync exposes currentStatus as SyncStatus, which is marked internal by
// the package. These tests must exercise that public API surface directly.
// ignore_for_file: invalid_use_of_internal_member

/*
Unit tests for GetAllLevelsApiImpl.

These tests ensure the API queries the level table, maps database rows into
LevelModel objects, and propagates database failures.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:powersync/powersync.dart';
import 'package:powersync/sqlite3.dart' as sqlite;
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/data/data_sources/get_all_levels_api_impl.dart';
import 'package:search_cms/features/dashboard/data/models/level_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../mocks/dashboard_mocks.mocks.dart';

// Minimal auth fake that exposes a non-null session so API precondition
// checks pass and the database query path can be tested.
class FakeAuthenticatedGoTrueClient extends Fake implements GoTrueClient {
  FakeAuthenticatedGoTrueClient(this._session);

  final Session _session;

  @override
  Session? get currentSession => _session;
}

// Minimal auth fake that exposes no active session so assertion-based
// precondition checks for unauthenticated access can be tested.
class FakeUnauthenticatedGoTrueClient extends Fake implements GoTrueClient {
  @override
  Session? get currentSession => null;
}

// Creates a minimal empty SQLite result set so Mockito has a concrete fallback
// value for PowerSync getAll() during stubbing and verification setup.
sqlite.ResultSet createEmptyResultSet() {
  final database = sqlite.sqlite3.openInMemory();

  database.execute('''
    CREATE TABLE level (
      id TEXT NOT NULL,
      unit_id TEXT NOT NULL,
      parent_id TEXT,
      name TEXT NOT NULL,
      level_char TEXT,
      level_int INTEGER,
      up_limit INTEGER,
      low_limit INTEGER,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    );
  ''');

  return database.select('SELECT * FROM level');
}

void main() {
  setUpAll(() {
    provideDummy<SyncStatus>(SyncStatus());
    provideDummy<sqlite.ResultSet>(createEmptyResultSet());
  });

  group('GetAllLevelsApiImpl', () {
    late MockPowerSyncDatabase mockPowerSyncDatabase;
    late MockSupabaseClient mockSupabaseClient;
    late GetAllLevelsApiImpl api;

    setUp(() async {
      await getIt.reset();

      mockPowerSyncDatabase = MockPowerSyncDatabase();
      mockSupabaseClient = MockSupabaseClient();

      final session = Session(
        accessToken: 'access-token',
        tokenType: 'bearer',
        user: User(
          id: 'user-1',
          appMetadata: const <String, dynamic>{},
          userMetadata: const <String, dynamic>{},
          aud: 'authenticated',
          createdAt: '2026-01-01T00:00:00.000Z',
        ),
      );

      when(mockSupabaseClient.auth)
          .thenReturn(FakeAuthenticatedGoTrueClient(session));

      when(mockPowerSyncDatabase.currentStatus).thenReturn(SyncStatus());

      getIt.registerSingleton<SupabaseClient>(mockSupabaseClient);

      api = GetAllLevelsApiImpl(powerSyncDatabase: mockPowerSyncDatabase);
    });

    tearDown(() async {
      await getIt.reset();
    });

    test('returns mapped LevelModel list when rows are returned', () async {
      final database = sqlite.sqlite3.openInMemory();

      database.execute('''
        CREATE TABLE level (
          id TEXT NOT NULL,
          unit_id TEXT NOT NULL,
          parent_id TEXT,
          name TEXT NOT NULL,
          level_char TEXT,
          level_int INTEGER,
          up_limit INTEGER,
          low_limit INTEGER,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        );
      ''');

      database.execute("""
        INSERT INTO level (
          id, unit_id, parent_id, name, level_char, level_int,
          up_limit, low_limit, created_at, updated_at
        )
        VALUES
          (
            'level-1', 'unit-1', NULL, ' Level One ', 'A', 1,
            0, 0, '2026-01-01T00:00:00.000Z', '2026-01-02T00:00:00.000Z'
          ),
          (
            'level-2', 'unit-2', 'level-1', 'Level Two', 'B', 2,
            1, 1, '2026-02-01T00:00:00.000Z', '2026-02-02T00:00:00.000Z'
          );
      """);

      final resultSet = database.select('SELECT * FROM level');

      when(mockPowerSyncDatabase.getAll('SELECT * FROM level'))
          .thenAnswer((_) async => resultSet);

      final result = await api.getAllLevels();

      expect(result, hasLength(2));

      expect(
        result[0],
        isA<LevelModel>()
            .having((level) => level.id, 'id', 'level-1')
            .having((level) => level.unitId, 'unitId', 'unit-1')
            .having((level) => level.parentId, 'parentId', isNull)
            .having((level) => level.name, 'name', 'Level One')
            .having((level) => level.levelChar, 'levelChar', 'A')
            .having((level) => level.levelInt, 'levelInt', 1)
            .having((level) => level.upLimit, 'upLimit', 0)
            .having((level) => level.lowLimit, 'lowLimit', 0)
            .having(
              (level) => level.createdAt,
          'createdAt',
          DateTime.parse('2026-01-01T00:00:00.000Z'),
        )
            .having(
              (level) => level.updatedAt,
          'updatedAt',
          DateTime.parse('2026-01-02T00:00:00.000Z'),
        ),
      );

      expect(
        result[1],
        isA<LevelModel>()
            .having((level) => level.id, 'id', 'level-2')
            .having((level) => level.unitId, 'unitId', 'unit-2')
            .having((level) => level.parentId, 'parentId', 'level-1')
            .having((level) => level.name, 'name', 'Level Two')
            .having((level) => level.levelChar, 'levelChar', 'B')
            .having((level) => level.levelInt, 'levelInt', 2)
            .having((level) => level.upLimit, 'upLimit', 1)
            .having((level) => level.lowLimit, 'lowLimit', 1)
            .having(
              (level) => level.createdAt,
          'createdAt',
          DateTime.parse('2026-02-01T00:00:00.000Z'),
        )
            .having(
              (level) => level.updatedAt,
          'updatedAt',
          DateTime.parse('2026-02-02T00:00:00.000Z'),
        ),
      );

      database.dispose();
    });

    test('returns an empty list when no rows are returned', () async {
      final database = sqlite.sqlite3.openInMemory();

      database.execute('''
        CREATE TABLE level (
          id TEXT NOT NULL,
          unit_id TEXT NOT NULL,
          parent_id TEXT,
          name TEXT NOT NULL,
          level_char TEXT,
          level_int INTEGER,
          up_limit INTEGER,
          low_limit INTEGER,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        );
      ''');

      final emptyResultSet = database.select('SELECT * FROM level');

      when(mockPowerSyncDatabase.getAll('SELECT * FROM level'))
          .thenAnswer((_) async => emptyResultSet);

      final result = await api.getAllLevels();

      expect(result, isEmpty);

      database.dispose();
    });

    test('queries the level table once', () async {
      final database = sqlite.sqlite3.openInMemory();

      database.execute('''
        CREATE TABLE level (
          id TEXT NOT NULL,
          unit_id TEXT NOT NULL,
          parent_id TEXT,
          name TEXT NOT NULL,
          level_char TEXT,
          level_int INTEGER,
          up_limit INTEGER,
          low_limit INTEGER,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        );
      ''');

      final resultSet = database.select('SELECT * FROM level');

      when(mockPowerSyncDatabase.getAll('SELECT * FROM level'))
          .thenAnswer((_) async => resultSet);

      await api.getAllLevels();

      verify(mockPowerSyncDatabase.currentStatus).called(1);
      verify(mockPowerSyncDatabase.getAll('SELECT * FROM level')).called(1);

      database.dispose();
    });

    test('rethrows when the database query fails', () async {
      final exception = Exception('database failure');

      when(mockPowerSyncDatabase.getAll('SELECT * FROM level'))
          .thenThrow(exception);

      expect(
        api.getAllLevels(),
        throwsA(same(exception)),
      );
    });

    test('throws AssertionError when PowerSync status has an error', () async {
      when(mockPowerSyncDatabase.currentStatus).thenReturn(
        SyncStatus(downloadError: Exception('sync failed')),
      );

      expect(
            () => api.getAllLevels(),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws AssertionError when no authenticated session exists', () async {
      when(mockSupabaseClient.auth)
          .thenReturn(FakeUnauthenticatedGoTrueClient());

      expect(
            () => api.getAllLevels(),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}