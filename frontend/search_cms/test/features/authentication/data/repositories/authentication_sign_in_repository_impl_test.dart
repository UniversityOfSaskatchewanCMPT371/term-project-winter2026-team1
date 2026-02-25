/// Unit tests for AuthenticationSignInRepositoryImpl.
///
/// The repository is responsible for translating data-layer models into domain entities
/// and converting API outcomes into domain Results (Success/Failure).
/// These tests validate role mapping, null handling, exception handling, and preconditions.
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/features/authentication/data/models/user_model.dart';
import 'package:search_cms/features/authentication/data/repositories/authentication_sign_in_repository_impl.dart';
import 'package:search_cms/features/authentication/domain/entities/user_entity.dart';
import 'package:search_cms/features/authentication/domain/entities/authentication_sign_in_result_classes.dart'
as auth_results;

import '../../mocks/authentication_mocks.mocks.dart';

void main() {
  group('AuthenticationSignInRepositoryImpl', () {
    // Verifies the repository returns Success and maps the role string to Role enum.
    test('returns Success and maps role correctly', () async {
      final api = MockAbstractAuthenticationSignInApi();

      when(api.signIn('abc@abc.com', '123456')).thenAnswer(
            (_) async => UserModel(id: 'u1', role: 'viewer'),
      );

      final repo = AuthenticationSignInRepositoryImpl(api: api);

      final Result result = await repo.signIn('abc@abc.com', '123456');

      expect(result, isA<auth_results.Success>());
      final success = result as auth_results.Success;

      expect(success.userEntity.id, 'u1');
      expect(success.userEntity.role, Role.viewer);

      verify(api.signIn('abc@abc.com', '123456')).called(1);
      verifyNoMoreInteractions(api);
    });

    // Verifies that a null user from the API returns Failure("Login Failed").
    test('returns Failure when API returns null', () async {
      final api = MockAbstractAuthenticationSignInApi();
      when(api.signIn('abc@abc.com', '123456')).thenAnswer((_) async => null);

      final repo = AuthenticationSignInRepositoryImpl(api: api);

      final Result result = await repo.signIn('abc@abc.com', '123456');

      expect(result, isA<auth_results.Failure>());
      expect((result as auth_results.Failure).errorMessage, 'Login Failed');

      verify(api.signIn('abc@abc.com', '123456')).called(1);
      verifyNoMoreInteractions(api);
    });

    // Verifies that exceptions thrown by the API are caught and returned as Failure(errorMessage).
    test('returns Failure when API throws', () async {
      final api = MockAbstractAuthenticationSignInApi();
      when(api.signIn('abc@abc.com', '123456')).thenThrow(Exception('boom'));

      final repo = AuthenticationSignInRepositoryImpl(api: api);

      final Result result = await repo.signIn('abc@abc.com', '123456');

      expect(result, isA<auth_results.Failure>());
      expect((result as auth_results.Failure).errorMessage, contains('boom'));

      verify(api.signIn('abc@abc.com', '123456')).called(1);
      verifyNoMoreInteractions(api);
    });

    // Verifies the repository returns Failure when password is shorter than 6 characters.
    test('returns Failure when password length < 6', () async {
      final api = MockAbstractAuthenticationSignInApi();
      final repo = AuthenticationSignInRepositoryImpl(api: api);

      final result = await repo.signIn('abc@abc.com', '12345');

      expect(result, isA<auth_results.Failure>());
      verifyZeroInteractions(api);
    });

    // Verifies the repository returns Failure when password is longer than 72 characters.
    test('returns Failure when password length > 72', () async {
      final api = MockAbstractAuthenticationSignInApi();
      final repo = AuthenticationSignInRepositoryImpl(api: api);

      final longPassword = 'a' * 73;

      final result = await repo.signIn('abc@abc.com', longPassword);

      expect(result, isA<auth_results.Failure>());
      verifyZeroInteractions(api);
    });
  });
}