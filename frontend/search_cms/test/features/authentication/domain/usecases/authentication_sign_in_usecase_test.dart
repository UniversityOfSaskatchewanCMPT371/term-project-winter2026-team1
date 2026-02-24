import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/features/authentication/domain/entities/user_entity.dart';
import 'package:search_cms/features/authentication/domain/repositories/abstract_authentication_sign_in_repository.dart';
import 'package:search_cms/features/authentication/domain/usecases/authentication_sign_in_usecase.dart';
import 'authentication_sign_in_usecase_test.mocks.dart';
import 'package:search_cms/features/authentication/domain/entities/authentication_sign_in_result_classes.dart'
    as authentication_sign_in_result_classes;

/*
  To use mocking, you need to run
    flutter pub run build_runner build
  after you define the mocks. This will generate the mocking files for you.

  Mocking should be done on the interfaces (the Abstract classes).
  Because this is the cleanest way to test without worrying about the details of
  the implementations.
 */
@GenerateNiceMocks([MockSpec<AbstractAuthenticationSignInRepository>()])
void main() {
  test(
    'Test for the sign in function in AuthenticationSignInRepositoryImpl',
    () async {
      final MockAbstractAuthenticationSignInRepository mockRepository =
          MockAbstractAuthenticationSignInRepository();

      // Define the response
      when(mockRepository.signIn('abc@abc.com', '123456')).thenAnswer(
        (_) async => authentication_sign_in_result_classes.Success(
          userEntity: UserEntity(
            id: 'e0bc4427-2286-4773-ba74-c4491ba5f1be',
            role: Role.viewer,
          ),
        ),
      );
      when(mockRepository.signIn('abc@abc.com', '1234567')).thenAnswer(
            (_) async => authentication_sign_in_result_classes.Failure(
          errorMessage: 'Login Failed'
        ),
      );
      when(mockRepository.signIn('admin@abc.com', 'verySecurePassword123456')).thenAnswer(
            (_) async => authentication_sign_in_result_classes.Failure(
            errorMessage: 'Login Failed'
        ),
      );

      AuthenticationSignInUsecase authenticationSignInUsecase =
          AuthenticationSignInUsecase(repository: mockRepository);

      // Test Case 1: This should log in successfully
      Result result1 = await authenticationSignInUsecase.call('abc@abc.com', '123456');
      if (result1 is authentication_sign_in_result_classes.Success) {
        expect(result1.userEntity.id, 'e0bc4427-2286-4773-ba74-c4491ba5f1be');
        expect(result1.userEntity.role, Role.viewer);
      } else {
        fail('Expect result1 to be authentication_sign_in_result_classes.Success, but not true');

      }

      // Test Case 2: This should fail due to password miss match
      final Result result2 =
      await authenticationSignInUsecase.call('abc@abc.com', '1234567');
      if (result2 is authentication_sign_in_result_classes.Failure) {
        expect(result2.errorMessage, 'Login Failed');
      } else {
        fail('Expect result2 to be authentication_sign_in_result_classes.Failure, but not true');
      }

      // Test Case 3: This should fail due to non-exist credential
      final Result result3 =
      await authenticationSignInUsecase.call('admin@abc.com', 'verySecurePassword123456');
      if (result3 is authentication_sign_in_result_classes.Failure) {
        expect(result3.errorMessage, 'Login Failed');
      } else {
        fail('Expect result3 to be authentication_sign_in_result_classes.Failure, but not true');
      }
    },
  );
}
