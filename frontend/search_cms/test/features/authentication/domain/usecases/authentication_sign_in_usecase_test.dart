/// Unit tests for AuthenticationSignInUsecase.
///
/// These tests ensure the usecase enforces its preconditions and delegates to the repository.
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/features/authentication/domain/entities/authentication_sign_in_result_classes.dart'
as auth_results;
import 'package:search_cms/features/authentication/domain/entities/user_entity.dart';
import 'package:search_cms/features/authentication/domain/usecases/authentication_sign_in_usecase.dart';

import '../../mocks/authentication_mocks.mocks.dart';

void main() {
  group('AuthenticationSignInUsecase', () {
    // Verifies the usecase calls repository.signIn and returns the same Result.
    test('delegates to repository and returns Result', () async {
      final repo = MockAbstractAuthenticationSignInRepository();

      when(repo.signIn('abc@abc.com', '123456')).thenAnswer(
            (_) async => auth_results.Success(
          userEntity: UserEntity(id: 'u1', role: Role.viewer),
        ),
      );

      final usecase = AuthenticationSignInUsecase(repository: repo);

      final Result result = await usecase('abc@abc.com', '123456');

      expect(result, isA<auth_results.Success>());
      verify(repo.signIn('abc@abc.com', '123456')).called(1);
      verifyNoMoreInteractions(repo);
    });

    // Verifies the usecase asserts when password is shorter than 6 characters.
    test('asserts when password length < 6', () async {
      final repo = MockAbstractAuthenticationSignInRepository();
      final usecase = AuthenticationSignInUsecase(repository: repo);

      expect(
            () => usecase('abc@abc.com', '12345'),
        throwsA(isA<AssertionError>()),
      );

      verifyZeroInteractions(repo);
    });

    // Verifies the usecase asserts when password is longer than 72 characters.
    test('asserts when password length > 72', () async {
      final repo = MockAbstractAuthenticationSignInRepository();
      final usecase = AuthenticationSignInUsecase(repository: repo);

      final longPassword = 'a' * 73;

      expect(
            () => usecase('abc@abc.com', longPassword),
        throwsA(isA<AssertionError>()),
      );

      verifyZeroInteractions(repo);
    });
  });
}