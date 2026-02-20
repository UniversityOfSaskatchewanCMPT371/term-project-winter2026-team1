import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/features/authentication/data/data_sources/abstract_authentication_sign_in_api.dart';
import 'package:search_cms/features/authentication/data/models/user_model.dart';
import 'package:search_cms/features/authentication/data/repositories/authentication_sign_in_repository_impl.dart';
import 'package:search_cms/features/authentication/domain/entities/authentication_sign_in_result_classes.dart' as authentication_sign_in_result_classes;
import 'package:search_cms/features/authentication/domain/entities/user_entity.dart';
import 'authentication_sign_in_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AbstractAuthenticationSignInApi>()])
void main() {
  test('Test for the sign in function in AuthenticationSignInRepositoryImpl',
    () async {
      final MockAbstractAuthenticationSignInApi mockApi = MockAbstractAuthenticationSignInApi();
      when(mockApi.signIn('abc@abc.com', '123456')).thenAnswer(
        (_) async => UserModel(
          id: 'e0bc4427-2286-4773-ba74-c4491ba5f1be',
          role: 'viewer',
        ));

      AuthenticationSignInRepositoryImpl authenticationSignInRepositoryImpl =
        AuthenticationSignInRepositoryImpl(api: mockApi);

      // Test Case 1: This should log in successfully
      final Result authResult1 = await authenticationSignInRepositoryImpl.signIn('abc@abc.com', '123456');

      expect(authResult1.runtimeType,
          authentication_sign_in_result_classes.Success);
      if (authResult1 is authentication_sign_in_result_classes.Success) {
        expect(authResult1.userEntity.id, 'e0bc4427-2286-4773-ba74-c4491ba5f1be');
        expect(authResult1.userEntity.role, Role.viewer);
      } else {
        fail('Expect authResult to be authentication_sign_in_result_classes.Success, but not true');
      }

      // Test Case 2: This should fail due to password miss match
      final Result authResult2 =
        await authenticationSignInRepositoryImpl.signIn('abc@abc.com', '1234567');
      if (authResult2 is authentication_sign_in_result_classes.Failure) {
        expect(authResult2.errorMessage, 'Login Failed');
      } else {
        fail('Expect authResult to be authentication_sign_in_result_classes.Failure, but not true');
      }

      // Test Case 3: This should fail due to non-exist credential
      final Result authResult3 =
        await authenticationSignInRepositoryImpl.signIn('admin@abc.com', 'verySecurePassword123456');
      if (authResult3 is authentication_sign_in_result_classes.Failure) {
        expect(authResult3.errorMessage, 'Login Failed');
      } else {
        fail('Expect authResult to be authentication_sign_in_result_classes.Failure, but not true');
      }
    }
  );
}