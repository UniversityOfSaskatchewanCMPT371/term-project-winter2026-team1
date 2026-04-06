/*
Tests for authentication dependency injection wiring.

These tests verify that initAuthenticationInjections registers expected factories/singletons
and that GetIt can resolve them.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:powersync/powersync.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/authentication/authentication_injections.dart';
import 'package:search_cms/features/authentication/data/data_sources/authentication_sign_in_api_impl.dart';
import 'package:search_cms/features/authentication/data/repositories/authentication_sign_in_repository_impl.dart';
import 'package:search_cms/features/authentication/domain/usecases/authentication_sign_in_usecase.dart';
import 'package:search_cms/features/authentication/domain/usecases/authentication_usecases.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'mocks/authentication_mocks.mocks.dart';

void main() {
  group('initAuthenticationInjections', () {
    late MockSupabaseClient mockSupabaseClient;
    late MockPowerSyncDatabase mockPowerSyncDatabase;

    setUp(() async {
      await getIt.reset();

      mockSupabaseClient = MockSupabaseClient();
      mockPowerSyncDatabase = MockPowerSyncDatabase();

      getIt.registerSingleton<SupabaseClient>(mockSupabaseClient);
      getIt.registerSingleton<PowerSyncDatabase>(mockPowerSyncDatabase);
    });

    tearDown(() async {
      await getIt.reset();
    });

    // Verifies expected types are registered and resolvable from GetIt.
    test('registers all authentication dependencies', () {
      initAuthenticationInjections();

      expect(getIt.isRegistered<AuthenticationSignInApiImpl>(), isTrue);
      expect(getIt.isRegistered<AuthenticationSignInRepositoryImpl>(), isTrue);
      expect(getIt.isRegistered<AuthenticationSignInUsecase>(), isTrue);
      expect(getIt.isRegistered<AuthenticationUsecases>(), isTrue);

      expect(getIt<AuthenticationSignInApiImpl>(), isA<AuthenticationSignInApiImpl>());
      expect(getIt<AuthenticationSignInRepositoryImpl>(), isA<AuthenticationSignInRepositoryImpl>());
      expect(getIt<AuthenticationSignInUsecase>(), isA<AuthenticationSignInUsecase>());
      expect(getIt<AuthenticationUsecases>(), isA<AuthenticationUsecases>());
    });

    // Verifies factories produce new instances and lazy singletons return the same instance.
    test('factory vs singleton lifetimes behave as expected', () {
      initAuthenticationInjections();

      final api1 = getIt<AuthenticationSignInApiImpl>();
      final api2 = getIt<AuthenticationSignInApiImpl>();
      expect(api1, isNot(same(api2)));

      final u1 = getIt<AuthenticationUsecases>();
      final u2 = getIt<AuthenticationUsecases>();
      expect(u1, same(u2));
    });
  });
}