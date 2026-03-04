/*
Unit tests for UserModel.

UserModel is a simple data-layer object that holds authenticated user data.
These tests ensure the constructor continues to store fields correctly,
preventing accidental breaking changes during refactors.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/features/authentication/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    // Verifies the constructor stores the provided id and role.
    test('USER-MODEL-1-stores id and role', () {
      final model = UserModel(id: 'u1', role: 'viewer');

      expect(model.id, 'u1');
      expect(model.role, 'viewer');
    });

    // Verifies the model can hold expected role strings (no validation in model).
    test('USER-MODEL-2-supports known role strings', () {
      final viewer = UserModel(id: '1', role: 'viewer');
      final admin = UserModel(id: '2', role: 'admin');
      final researcher = UserModel(id: '3', role: 'researcher');

      expect(viewer.role, 'viewer');
      expect(admin.role, 'admin');
      expect(researcher.role, 'researcher');
    });
  });
}