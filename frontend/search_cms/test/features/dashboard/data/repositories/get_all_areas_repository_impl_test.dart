// PowerSync exposes currentStatus as SyncStatus, which is marked internal by
// the package. These tests must exercise that public API surface directly.
// ignore_for_file: invalid_use_of_internal_member

/*
Unit tests for GetAllAreasRepositoryImpl.

These tests ensure the repository enforces its preconditions, delegates to the
API, maps AreaModel objects into AreaEntity objects, and returns Result types.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/data/models/area_model.dart';
import 'package:search_cms/features/dashboard/data/repositories/get_all_areas_repository_impl.dart';
import 'package:search_cms/features/dashboard/domain/entities/get_all_areas_result_classes.dart'
as get_all_areas_result_classes;
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

  group('GetAllAreasRepositoryImpl', () {
    late MockAbstractGetAllAreasApi mockApi;
    late MockPowerSyncDatabase mockPowerSyncDatabase;
    late MockSupabaseClient mockSupabaseClient;
    late GetAllAreasRepositoryImpl repository;

    setUp(() async {
      await getIt.reset();

      mockApi = MockAbstractGetAllAreasApi();
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

      when(mockPowerSyncDatabase.currentStatus).thenReturn(SyncStatus());
      when(mockSupabaseClient.auth)
          .thenReturn(FakeAuthenticatedGoTrueClient(session));

      getIt.registerSingleton<PowerSyncDatabase>(mockPowerSyncDatabase);
      getIt.registerSingleton<SupabaseClient>(mockSupabaseClient);

      repository = GetAllAreasRepositoryImpl(api: mockApi);
    });

    tearDown(() async {
      await getIt.reset();
    });

    test('GET-ALL-AREAS-REPO-1-returns Success with mapped AreaEntity list when API succeeds',
            () async {
          final listOfAreaModel = <AreaModel>[
            AreaModel(
              id: 'area-1',
              name: 'Alpha Area',
              createdAt: DateTime.parse('2026-01-01T00:00:00.000Z'),
              updatedAt: DateTime.parse('2026-01-02T00:00:00.000Z'),
            ),
            AreaModel(
              id: 'area-2',
              name: 'Beta Area',
              createdAt: DateTime.parse('2026-02-01T00:00:00.000Z'),
              updatedAt: DateTime.parse('2026-02-02T00:00:00.000Z'),
            ),
          ];

          when(mockApi.getAllAreas()).thenAnswer((_) async => listOfAreaModel);

          final result = await repository.getAllAreas();

          expect(result, isA<get_all_areas_result_classes.Success>());

          final success = result as get_all_areas_result_classes.Success;

          expect(success.listOfAreaEntity, hasLength(2));

          expect(
            success.listOfAreaEntity[0],
            isA<dynamic>()
                .having((area) => area.id, 'id', 'area-1')
                .having((area) => area.name, 'name', 'Alpha Area')
                .having(
                  (area) => area.createdAt,
              'createdAt',
              DateTime.parse('2026-01-01T00:00:00.000Z'),
            )
                .having(
                  (area) => area.updatedAt,
              'updatedAt',
              DateTime.parse('2026-01-02T00:00:00.000Z'),
            ),
          );

          expect(
            success.listOfAreaEntity[1],
            isA<dynamic>()
                .having((area) => area.id, 'id', 'area-2')
                .having((area) => area.name, 'name', 'Beta Area')
                .having(
                  (area) => area.createdAt,
              'createdAt',
              DateTime.parse('2026-02-01T00:00:00.000Z'),
            )
                .having(
                  (area) => area.updatedAt,
              'updatedAt',
              DateTime.parse('2026-02-02T00:00:00.000Z'),
            ),
          );

          verify(mockPowerSyncDatabase.currentStatus).called(1);
          verify(mockApi.getAllAreas()).called(1);
        });

    test('GET-ALL-AREAS-REPO-2-returns Success with an empty list when API returns no areas',
            () async {
          when(mockApi.getAllAreas()).thenAnswer((_) async => <AreaModel>[]);

          final result = await repository.getAllAreas();

          expect(result, isA<get_all_areas_result_classes.Success>());

          final success = result as get_all_areas_result_classes.Success;
          expect(success.listOfAreaEntity, isEmpty);

          verify(mockPowerSyncDatabase.currentStatus).called(1);
          verify(mockApi.getAllAreas()).called(1);
        });

    test('GET-ALL-AREAS-REPO-3-returns Failure when API throws an exception', () async {
      when(mockApi.getAllAreas()).thenThrow(Exception('api failure'));

      final result = await repository.getAllAreas();

      expect(result, isA<get_all_areas_result_classes.Failure>());

      final failure = result as get_all_areas_result_classes.Failure;
      expect(failure.errorMessage, contains('Exception: api failure'));

      verify(mockPowerSyncDatabase.currentStatus).called(1);
      verify(mockApi.getAllAreas()).called(1);
    });

    test('GET-ALL-AREAS-REPO-4-returns Failure when PowerSync status has an error', () async {
      when(
        mockPowerSyncDatabase.currentStatus,
      ).thenReturn(
        SyncStatus(downloadError: Exception('sync failed')),
      );

      final result = await repository.getAllAreas();

      expect(result, isA<get_all_areas_result_classes.Failure>());

      final failure = result as get_all_areas_result_classes.Failure;
      expect(
        failure.errorMessage,
        contains('getIt<PowerSyncDatabase>().currentStatus.anyError == null'),
      );

      verify(mockPowerSyncDatabase.currentStatus).called(1);
      verifyNever(mockApi.getAllAreas());
    });

    test('GET-ALL-AREAS-REPO-5-returns Failure when no authenticated session exists', () async {
      when(
        mockSupabaseClient.auth,
      ).thenReturn(FakeUnauthenticatedGoTrueClient());

      final result = await repository.getAllAreas();

      expect(result, isA<get_all_areas_result_classes.Failure>());

      final failure = result as get_all_areas_result_classes.Failure;
      expect(
        failure.errorMessage,
        contains('getIt<SupabaseClient>().auth.currentSession != null'),
      );

      verify(mockPowerSyncDatabase.currentStatus).called(1);
      verifyNever(mockApi.getAllAreas());
    });
  });
}