/*
Tests for UserEntity construction.

UserEntity is a simple domain object used throughout the auth flow.
These tests ensure the entity stores the expected values and that Role values
are stable for downstream logic (repo mapping, UI behavior).
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/features/authentication/domain/entities/user_entity.dart';

void main() {
  group('UserEntity', () {
    // Verifies UserEntity stores the id and role passed to the constructor.
    test('stores id and role', () {
      final user = UserEntity(id: 'u1', role: Role.admin);

      expect(user.id, 'u1');
      expect(user.role, Role.admin);
    });

    // Verifies Role enum contains the expected values.
    test('Role enum contains expected values', () {
      expect(Role.values, containsAll([Role.admin, Role.researcher, Role.viewer]));
    });
  });
}