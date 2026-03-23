// PowerSync exposes currentStatus as SyncStatus, which is marked internal by
// the package. These tests must exercise that public API surface directly.
// ignore_for_file: invalid_use_of_internal_member

/*
Unit tests for GetAllAreasUseCase.

These tests ensure the use case enforces its preconditions, delegates to the
repository, and returns the repository result unchanged.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/domain/entities/area_entity.dart';
import 'package:search_cms/features/dashboard/domain/entities/get_all_areas_result_classes.dart'
as get_all_areas_result_classes;
import 'package:search_cms/features/dashboard/domain/usecases/get_all_areas_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../mocks/dashboard_mocks.mocks.dart';

// Minimal auth fake that exposes a non-null session so use case precondition
// checks pass and repository delegation can be tested.
class FakeAuthenticatedGoTrueClient extends Fake implements GoTrueClient {
  FakeAuthenticatedGoTrueClient(this._session);

  final Session _session;

  @override
  Session? get currentSession => _session;
}

// Minimal auth fake that exposes no active session so assertion-based
// unauthenticated precondition checks can be tested.
class FakeUnauthenticatedGoTrueClient extends Fake implements GoTrueClient {
  @override
  Session? get currentSession => null;
}

void main() {
  setUpAll(() {
    provideDummy<SyncStatus>(SyncStatus());
  });

  group('GetAllAreasUseCase', () {
    late MockAbstractGetAllAreasRepository mockRepository;
    late MockPowerSyncDatabase mockPowerSyncDatabase;
    late MockSupabaseClient mockSupabaseClient;
    late GetAllAreasUseCase useCase;

    setUp(() async {
      await getIt.reset();

      mockRepository = MockAbstractGetAllAreasRepository();
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

      useCase = GetAllAreasUseCase(repository: mockRepository);
    });

    tearDown(() async {
      await getIt.reset();
    });

    test('GET-ALL-AREAS-USECASE-1-returns Success from the repository unchanged', () async {
      final success = get_all_areas_result_classes.Success(
        listOfAreaEntity: <AreaEntity>[
          AreaEntity(
            id: 'area-1',
            name: 'Alpha Area',
            createdAt: DateTime.parse('2026-01-01T00:00:00.000Z'),
            updatedAt: DateTime.parse('2026-01-02T00:00:00.000Z'),
          ),
        ],
      );

      when(mockRepository.getAllAreas()).thenAnswer((_) async => success);

      final result = await useCase();

      expect(result, same(success));

      verify(mockPowerSyncDatabase.currentStatus).called(1);
      verify(mockRepository.getAllAreas()).called(1);
    });

    test('GET-ALL-AREAS-USECASE-2-returns Failure from the repository unchanged', () async {
      final failure = get_all_areas_result_classes.Failure(
        errorMessage: 'repository failure',
      );

      when(mockRepository.getAllAreas()).thenAnswer((_) async => failure);

      final result = await useCase();

      expect(result, same(failure));

      verify(mockPowerSyncDatabase.currentStatus).called(1);
      verify(mockRepository.getAllAreas()).called(1);
    });

    test('GET-ALL-AREAS-USECASE-3-calls repository.getAllAreas once', () async {
      final success = get_all_areas_result_classes.Success(
        listOfAreaEntity: <AreaEntity>[],
      );

      when(mockRepository.getAllAreas()).thenAnswer((_) async => success);

      await useCase();

      verify(mockPowerSyncDatabase.currentStatus).called(1);
      verify(mockRepository.getAllAreas()).called(1);
    });

    test('GET-ALL-AREAS-USECASE-4-throws AssertionError when PowerSync status has an error', () async {
      when(
        mockPowerSyncDatabase.currentStatus,
      ).thenReturn(
        SyncStatus(downloadError: Exception('sync failed')),
      );

      expect(
            () => useCase(),
        throwsA(isA<AssertionError>()),
      );

      verify(mockPowerSyncDatabase.currentStatus).called(1);
      verifyNever(mockRepository.getAllAreas());
    });

    test('GET-ALL-AREAS-USECASE-5-throws AssertionError when no authenticated session exists', () async {
      when(
        mockSupabaseClient.auth,
      ).thenReturn(FakeUnauthenticatedGoTrueClient());

      expect(
            () => useCase(),
        throwsA(isA<AssertionError>()),
      );

      verify(mockPowerSyncDatabase.currentStatus).called(1);
      verifyNever(mockRepository.getAllAreas());
    });
  });
}