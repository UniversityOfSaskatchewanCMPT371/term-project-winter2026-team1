/// Tests for authentication sign-in result classes.
///
/// These tests ensure Success carries a UserEntity and Failure carries an error message.
import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/features/authentication/domain/entities/authentication_sign_in_result_classes.dart';
import 'package:search_cms/features/authentication/domain/entities/user_entity.dart';

void main() {
  group('AuthenticationSignInResultClasses', () {
    // Verifies Success is a Result and stores a UserEntity payload.
    test('Success stores userEntity', () {
      final user = UserEntity(id: '123', role: Role.viewer);
      final result = Success(userEntity: user);

      expect(result, isA<Result>());
      expect(result.userEntity, same(user));
    });

    // Verifies Failure is a Result and stores an errorMessage payload.
    test('Failure stores errorMessage', () {
      final result = Failure(errorMessage: 'Login Failed');

      expect(result, isA<Result>());
      expect(result.errorMessage, 'Login Failed');
    });
  });
}