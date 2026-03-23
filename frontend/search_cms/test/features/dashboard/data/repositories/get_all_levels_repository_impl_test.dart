// PowerSync exposes currentStatus as SyncStatus, which is marked internal by
// the package. These tests must exercise that public API surface directly.
// ignore_for_file: invalid_use_of_internal_member

/*
Unit tests for GetAllLevelsRepositoryImpl.

These tests ensure the repository enforces its preconditions, delegates to the
API, maps LevelModel objects into LevelEntity objects, and returns Result types.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/data/models/level_model.dart';
import 'package:search_cms/features/dashboard/data/repositories/get_all_levels_repository_impl.dart';
import 'package:search_cms/features/dashboard/domain/entities/get_all_levels_result_classes.dart'
as get_all_levels_result_classes;
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

  group('GetAllLevelsRepositoryImpl', () {
    late MockAbstractGetAllLevelsApi mockApi;
    late MockPowerSyncDatabase mockPowerSyncDatabase;
    late MockSupabaseClient mockSupabaseClient;
    late GetAllLevelsRepositoryImpl repository;

    setUp(() async {
      await getIt.reset();

      mockApi = MockAbstractGetAllLevelsApi();
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

      repository = GetAllLevelsRepositoryImpl(api: mockApi);
    });

    tearDown(() async {
      await getIt.reset();
    });

    test('GET-ALL-LEVELS-REPO-1-returns Success with mapped LevelEntity list when API succeeds',
            () async {
          final listOfLevelModel = <LevelModel>[
            LevelModel(
              id: 'level-1',
              unitId: 'unit-1',
              parentId: null,
              name: 'Level One',
              levelChar: 'A',
              levelInt: 1,
              upLimit: 0,
              lowLimit: 0,
              createdAt: DateTime.parse('2026-01-01T00:00:00.000Z'),
              updatedAt: DateTime.parse('2026-01-02T00:00:00.000Z'),
            ),
            LevelModel(
              id: 'level-2',
              unitId: 'unit-2',
              parentId: 'level-1',
              name: 'Level Two',
              levelChar: 'B',
              levelInt: 2,
              upLimit: 1,
              lowLimit: 1,
              createdAt: DateTime.parse('2026-02-01T00:00:00.000Z'),
              updatedAt: DateTime.parse('2026-02-02T00:00:00.000Z'),
            ),
          ];

          when(mockApi.getAllLevels()).thenAnswer((_) async => listOfLevelModel);

          final result = await repository.getAllLevels();

          expect(result, isA<get_all_levels_result_classes.Success>());

          final success = result as get_all_levels_result_classes.Success;

          expect(success.listOfLevelEntity, hasLength(2));

          expect(
            success.listOfLevelEntity[0],
            isA<dynamic>()
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
            success.listOfLevelEntity[1],
            isA<dynamic>()
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

          verify(mockPowerSyncDatabase.currentStatus).called(1);
          verify(mockApi.getAllLevels()).called(1);
        });

    test('GET-ALL-LEVELS-REPO-2-returns Success with an empty list when API returns no levels',
            () async {
          when(mockApi.getAllLevels()).thenAnswer((_) async => <LevelModel>[]);

          final result = await repository.getAllLevels();

          expect(result, isA<get_all_levels_result_classes.Success>());

          final success = result as get_all_levels_result_classes.Success;
          expect(success.listOfLevelEntity, isEmpty);

          verify(mockPowerSyncDatabase.currentStatus).called(1);
          verify(mockApi.getAllLevels()).called(1);
        });

    test('GET-ALL-LEVELS-REPO-3-returns Failure when API throws an exception', () async {
      when(mockApi.getAllLevels()).thenThrow(Exception('api failure'));

      final result = await repository.getAllLevels();

      expect(result, isA<get_all_levels_result_classes.Failure>());

      final failure = result as get_all_levels_result_classes.Failure;
      expect(failure.errorMessage, contains('Exception: api failure'));

      verify(mockPowerSyncDatabase.currentStatus).called(1);
      verify(mockApi.getAllLevels()).called(1);
    });

    test('GET-ALL-LEVELS-REPO-4-returns Failure when PowerSync status has an error', () async {
      when(
        mockPowerSyncDatabase.currentStatus,
      ).thenReturn(
        SyncStatus(downloadError: Exception('sync failed')),
      );

      final result = await repository.getAllLevels();

      expect(result, isA<get_all_levels_result_classes.Failure>());

      final failure = result as get_all_levels_result_classes.Failure;
      expect(
        failure.errorMessage,
        contains('getIt<PowerSyncDatabase>().currentStatus.anyError == null'),
      );

      verify(mockPowerSyncDatabase.currentStatus).called(1);
      verifyNever(mockApi.getAllLevels());
    });

    test('GET-ALL-LEVELS-REPO-5-returns Failure when no authenticated session exists', () async {
      when(
        mockSupabaseClient.auth,
      ).thenReturn(FakeUnauthenticatedGoTrueClient());

      final result = await repository.getAllLevels();

      expect(result, isA<get_all_levels_result_classes.Failure>());

      final failure = result as get_all_levels_result_classes.Failure;
      expect(
        failure.errorMessage,
        contains('getIt<SupabaseClient>().auth.currentSession != null'),
      );

      verify(mockPowerSyncDatabase.currentStatus).called(1);
      verifyNever(mockApi.getAllLevels());
    });
  });
}