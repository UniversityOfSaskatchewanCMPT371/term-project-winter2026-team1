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
  test('Test the sign in function in AuthenticationSignInRepositoryImpl',
    () async {
      final mockApi = MockAbstractAuthenticationSignInApi();
      when(mockApi.signIn('abc@abc.com', '123456')).thenAnswer(
        (_) async => UserModel(
          id: 'random-id',
          role: 'viewer',
        ));

      AuthenticationSignInRepositoryImpl authenticationSignInRepositoryImpl =
        AuthenticationSignInRepositoryImpl(api: mockApi);

      Result authResult = await authenticationSignInRepositoryImpl.signIn('abc@abc.com', '123456');

      expect(authResult.runtimeType,
          authentication_sign_in_result_classes.Success);
      if (authResult is authentication_sign_in_result_classes.Success) {
        expect(authResult.userEntity.id, 'random-id');
        expect(authResult.userEntity.role, Role.viewer);
      } else {
        fail('Expect authResult to be authentication_sign_in_result_classes.Success, but not true');
      }
    }
  );
}