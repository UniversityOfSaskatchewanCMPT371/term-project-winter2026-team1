// PowerSync exposes currentStatus as SyncStatus, which is marked internal by
// the package. These tests must exercise that public API surface directly.
// ignore_for_file: invalid_use_of_internal_member

/*
Unit tests for GetAllSitesRepositoryImpl.

These tests ensure the repository enforces its preconditions, delegates to the
API, maps SiteModel objects into SiteEntity objects, and returns Result types.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/data/models/site_model.dart';
import 'package:search_cms/features/dashboard/data/repositories/get_all_sites_repository_impl.dart';
import 'package:search_cms/features/dashboard/domain/entities/get_all_sites_result_classes.dart'
as get_all_sites_result_classes;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../mocks/dashboard_mocks.mocks.dart';

// Minimal auth fake that exposes a non-null session so repository precondition
// checks pass and the API delegation path can be tested.
class FakeAuthenticatedGoTrueClient extends Fake implements GoTrueClient {
  FakeAuthenticatedGoTrueClient(this._session);

  final Session _session;

  @override
  Session? get currentSession => _session;
}

// Minimal auth fake that exposes no active session so repository
// unauthenticated precondition handling can be tested.
class FakeUnauthenticatedGoTrueClient extends Fake implements GoTrueClient {
  @override
  Session? get currentSession => null;
}

void main() {
  setUpAll(() {
    provideDummy<SyncStatus>(SyncStatus());
  });

  group('GetAllSitesRepositoryImpl', () {
    late MockAbstractGetAllSitesApi mockApi;
    late MockPowerSyncDatabase mockPowerSyncDatabase;
    late MockSupabaseClient mockSupabaseClient;
    late GetAllSitesRepositoryImpl repository;

    setUp(() async {
      await getIt.reset();

      mockApi = MockAbstractGetAllSitesApi();
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
        mockPowerSyncDatabase.currentStatus,
      ).thenReturn(SyncStatus());

      when(
        mockSupabaseClient.auth,
      ).thenReturn(FakeAuthenticatedGoTrueClient(session));

      getIt.registerSingleton<PowerSyncDatabase>(mockPowerSyncDatabase);
      getIt.registerSingleton<SupabaseClient>(mockSupabaseClient);

      repository = GetAllSitesRepositoryImpl(api: mockApi);
    });

    tearDown(() async {
      await getIt.reset();
    });

    test('returns Success with mapped SiteEntity list when API succeeds',
            () async {
          final listOfSiteModel = <SiteModel>[
            SiteModel(
              id: 'site-1',
              name: 'Alpha Site',
              borden: 'BORD001',
              createdAt: DateTime.parse('2026-01-01T00:00:00.000Z'),
              updatedAt: DateTime.parse('2026-01-02T00:00:00.000Z'),
            ),
            SiteModel(
              id: 'site-2',
              name: null,
              borden: 'BORD002',
              createdAt: DateTime.parse('2026-02-01T00:00:00.000Z'),
              updatedAt: DateTime.parse('2026-02-02T00:00:00.000Z'),
            ),
          ];

          when(mockApi.getAllSites()).thenAnswer((_) async => listOfSiteModel);

          final result = await repository.getAllSites();

          expect(result, isA<get_all_sites_result_classes.Success>());

          final success = result as get_all_sites_result_classes.Success;

          expect(success.listOfSiteEntity, hasLength(2));

          expect(
            success.listOfSiteEntity[0],
            isA<dynamic>()
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
            success.listOfSiteEntity[1],
            isA<dynamic>()
                .having((site) => site.id, 'id', 'site-2')
                .having((site) => site.name, 'name', '')
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

          verify(mockPowerSyncDatabase.currentStatus).called(1);
          verify(mockApi.getAllSites()).called(1);
        });

    test('returns Success with an empty list when API returns no sites',
            () async {
          when(mockApi.getAllSites()).thenAnswer((_) async => <SiteModel>[]);

          final result = await repository.getAllSites();

          expect(result, isA<get_all_sites_result_classes.Success>());

          final success = result as get_all_sites_result_classes.Success;

          expect(success.listOfSiteEntity, isEmpty);

          verify(mockPowerSyncDatabase.currentStatus).called(1);
          verify(mockApi.getAllSites()).called(1);
        });

    test('returns Failure when API throws an exception', () async {
      when(mockApi.getAllSites()).thenThrow(Exception('api failure'));

      final result = await repository.getAllSites();

      expect(result, isA<get_all_sites_result_classes.Failure>());

      final failure = result as get_all_sites_result_classes.Failure;

      expect(failure.errorMessage, contains('Exception: api failure'));

      verify(mockPowerSyncDatabase.currentStatus).called(1);
      verify(mockApi.getAllSites()).called(1);
    });

    test('returns Failure when PowerSync status has an error', () async {
      when(
        mockPowerSyncDatabase.currentStatus,
      ).thenReturn(
        SyncStatus(downloadError: Exception('sync failed')),
      );

      final result = await repository.getAllSites();

      expect(result, isA<get_all_sites_result_classes.Failure>());

      final failure = result as get_all_sites_result_classes.Failure;

      expect(
        failure.errorMessage,
        contains('getIt<PowerSyncDatabase>().currentStatus.anyError == null'),
      );

      verify(mockPowerSyncDatabase.currentStatus).called(1);
      verifyNever(mockApi.getAllSites());
    });

    test('returns Failure when no authenticated session exists', () async {
      when(
        mockSupabaseClient.auth,
      ).thenReturn(FakeUnauthenticatedGoTrueClient());

      final result = await repository.getAllSites();

      expect(result, isA<get_all_sites_result_classes.Failure>());

      final failure = result as get_all_sites_result_classes.Failure;

      expect(
        failure.errorMessage,
        contains('getIt<SupabaseClient>().auth.currentSession != null'),
      );

      verify(mockPowerSyncDatabase.currentStatus).called(1);
      verifyNever(mockApi.getAllSites());
    });
  });
}