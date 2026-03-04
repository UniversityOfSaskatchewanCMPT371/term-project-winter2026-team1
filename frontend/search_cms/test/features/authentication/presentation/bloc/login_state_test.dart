/*
Tests for LoginState value equality.

These tests verify that LoginState subclasses correctly implement Equatable-based
equality. Bloc uses equality to decide whether a new state should trigger UI rebuilds.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/features/authentication/domain/entities/user_entity.dart';
import 'package:search_cms/features/authentication/presentation/bloc/login_state.dart';

void main() {
  group('LoginState Equality', () {
    // Verifies that two LoginInitial instances are considered equal.
    test('LOGIN-STATE-1-LoginInitial equality', () {
      expect(const LoginInitial(), equals(const LoginInitial()));
    });

    // Verifies that two LoginLoading instances are considered equal.
    test('LOGIN-STATE-2-LoginLoading equality', () {
      expect(const LoginLoading(), equals(const LoginLoading()));
    });

    // Verifies that LoginSuccess equality depends on the user entity.
    test('LOGIN-STATE-3-LoginSuccess equality (same user)', () {
      final user = UserEntity(id: '1', role: Role.viewer);
      expect(LoginSuccess(user), equals(LoginSuccess(user)));
    });

    // Verifies that LoginSuccess states with different users are NOT equal.
    test('LOGIN-STATE-4-LoginSuccess inequality (different users)', () {
      final user1 = UserEntity(id: '1', role: Role.viewer);
      final user2 = UserEntity(id: '2', role: Role.viewer);

      expect(LoginSuccess(user1), isNot(LoginSuccess(user2)));
    });

    // Verifies that LoginFailure equality depends on the error message.
    test('LOGIN-STATE-5-LoginFailure equality (same message)', () {
      expect(const LoginFailure('x'), equals(const LoginFailure('x')));
    });

    // Verifies that LoginFailure states with different messages are NOT equal.
    test('LOGIN-STATE-6-LoginFailure inequality (different message)', () {
      expect(const LoginFailure('x'), isNot(const LoginFailure('y')));
    });
  });
}