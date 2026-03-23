// PowerSync exposes currentStatus as SyncStatus, which is marked internal by
// the package. These tests must exercise that public API surface directly.
// ignore_for_file: invalid_use_of_internal_member

/*
Unit tests for GetAllSitesApiImpl.

These tests ensure the API queries the site table, maps database rows into
SiteModel objects, and propagates database failures.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:powersync/powersync.dart';
import 'package:powersync/sqlite3.dart' as sqlite;
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/data/data_sources/get_all_sites_api_impl.dart';
import 'package:search_cms/features/dashboard/data/models/site_model.dart';
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
    CREATE TABLE site (
      id TEXT NOT NULL,
      name TEXT,
      borden TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    );
  ''');

  return database.select('SELECT * FROM site');
}

void main() {
  setUpAll(() {
    provideDummy<SyncStatus>(SyncStatus());
    provideDummy<sqlite.ResultSet>(createEmptyResultSet());
  });

  group('GetAllSitesApiImpl', () {
    late MockPowerSyncDatabase mockPowerSyncDatabase;
    late MockSupabaseClient mockSupabaseClient;
    late GetAllSitesApiImpl api;

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

      when(
        mockSupabaseClient.auth,
      ).thenReturn(FakeAuthenticatedGoTrueClient(session));

      when(
        mockPowerSyncDatabase.currentStatus,
      ).thenReturn(SyncStatus());

      getIt.registerSingleton<SupabaseClient>(mockSupabaseClient);

      api = GetAllSitesApiImpl(powerSyncDatabase: mockPowerSyncDatabase);
    });

    tearDown(() async {
      await getIt.reset();
    });

    test('GET-ALL-SITES-API-1-returns mapped SiteModel list when rows are returned', () async {
      final database = sqlite.sqlite3.openInMemory();

      database.execute('''
        CREATE TABLE site (
          id TEXT NOT NULL,
          name TEXT,
          borden TEXT NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        );
      ''');

      database.execute("""
        INSERT INTO site (id, name, borden, created_at, updated_at)
        VALUES
          ('site-1', ' Alpha Site ', 'BORD001',
           '2026-01-01T00:00:00.000Z', '2026-01-02T00:00:00.000Z'),
          ('site-2', NULL, 'BORD002',
           '2026-02-01T00:00:00.000Z', '2026-02-02T00:00:00.000Z');
      """);

      final resultSet = database.select('SELECT * FROM site');

      when(
        mockPowerSyncDatabase.getAll('SELECT * FROM site'),
      ).thenAnswer((_) async => resultSet);

      final result = await api.getAllSites();

      expect(result, hasLength(2));

      expect(
        result[0],
        isA<SiteModel>()
            .having((site) => site.id, 'id', 'site-1')
            .having((site) => site.name, 'name', 'Alpha Site')
            .having((site) => site.borden, 'borden', 'BORD001')
            .having(
              (site) => site.createdAt,
          'createdAt',
          DateTime.parse('2026-01-01T00:00:00.000Z'),
        )
            .having(
              (site) => site.updatedAt,
          'updatedAt',
          DateTime.parse('2026-01-02T00:00:00.000Z'),
        ),
      );

      expect(
        result[1],
        isA<SiteModel>()
            .having((site) => site.id, 'id', 'site-2')
            .having((site) => site.name, 'name', isNull)
            .having((site) => site.borden, 'borden', 'BORD002')
            .having(
              (site) => site.createdAt,
          'createdAt',
          DateTime.parse('2026-02-01T00:00:00.000Z'),
        )
            .having(
              (site) => site.updatedAt,
          'updatedAt',
          DateTime.parse('2026-02-02T00:00:00.000Z'),
        ),
      );

      database.dispose();
    });

    test('GET-ALL-SITES-API-2-returns an empty list when no rows are returned', () async {
      final database = sqlite.sqlite3.openInMemory();

      database.execute('''
        CREATE TABLE site (
          id TEXT NOT NULL,
          name TEXT,
          borden TEXT NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        );
      ''');

      final emptyResultSet = database.select('SELECT * FROM site');

      when(
        mockPowerSyncDatabase.getAll('SELECT * FROM site'),
      ).thenAnswer((_) async => emptyResultSet);

      final result = await api.getAllSites();

      expect(result, isEmpty);

      database.dispose();
    });

    test('GET-ALL-SITES-API-3-queries the site table once', () async {
      final database = sqlite.sqlite3.openInMemory();

      database.execute('''
        CREATE TABLE site (
          id TEXT NOT NULL,
          name TEXT,
          borden TEXT NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        );
      ''');

      final resultSet = database.select('SELECT * FROM site');

      when(
        mockPowerSyncDatabase.getAll('SELECT * FROM site'),
      ).thenAnswer((_) async => resultSet);

      await api.getAllSites();

      verify(mockPowerSyncDatabase.currentStatus).called(1);
      verify(mockPowerSyncDatabase.getAll('SELECT * FROM site')).called(1);

      database.dispose();
    });

    test('GET-ALL-SITES-API-4-rethrows when the database query fails', () async {
      final exception = Exception('database failure');

      when(
        mockPowerSyncDatabase.getAll('SELECT * FROM site'),
      ).thenThrow(exception);

      expect(
        api.getAllSites(),
        throwsA(same(exception)),
      );
    });

    test('GET-ALL-SITES-API-5-throws AssertionError when PowerSync status has an error', () async {
      when(
        mockPowerSyncDatabase.currentStatus,
      ).thenReturn(
        SyncStatus(downloadError: Exception('sync failed')),
      );

      expect(
            () => api.getAllSites(),
        throwsA(isA<AssertionError>()),
      );
    });

    test('GET-ALL-SITES-API-6-throws AssertionError when no authenticated session exists', () async {
      when(
        mockSupabaseClient.auth,
      ).thenReturn(FakeUnauthenticatedGoTrueClient());

      expect(
            () => api.getAllSites(),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}