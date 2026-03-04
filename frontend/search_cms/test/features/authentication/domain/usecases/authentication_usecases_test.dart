/*
Tests for AuthenticationUsecases container.

These tests ensure it stores the expected usecase instance so GetIt wiring remains correct.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/features/authentication/domain/usecases/authentication_usecases.dart';

import '../../mocks/authentication_mocks.mocks.dart';

void main() {
  group('AuthenticationUsecases', () {
    // Verifies AuthenticationUsecases stores the provided AuthenticationSignInUsecase.
    test('DOMAIN-USECASE-1-stores authenticationSignInUsecase', () {
      final signIn = MockAuthenticationSignInUsecase();
      final usecases = AuthenticationUsecases(authenticationSignInUsecase: signIn);

      expect(usecases.authenticationSignInUsecase, same(signIn));
    });
  });
}