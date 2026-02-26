import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/features/authentication/data/data_sources/abstract_authentication_sign_in_api.dart';
import 'package:search_cms/features/authentication/data/models/user_model.dart';
import 'package:search_cms/features/authentication/data/repositories/authentication_sign_in_repository_impl.dart';
import 'package:search_cms/features/authentication/domain/entities/authentication_sign_in_result_classes.dart' as authentication_sign_in_result_classes;
import 'package:search_cms/features/authentication/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'authentication_sign_in_repository_impl_test.mocks.dart';


/*
To run write "flutter test" in the terminal (will run files with _test.dart in their name)

when to use mocking
when you want to unit test a class, say ClassToTest, which uses another class,
you insert a mock of the other class for it to use. That also implies that ClassToTest has a method
or parameter for a method that takes in an instance of the other class (which we will use to insert the mock instead)
ex ClassToTest.someFunction(mock);
ex AuthenticationSignInRepositoryImpl(api) //in the actual use it would be passed an instance of AuthenticationSignInApiImpl which is what we will be mocking

The mocking of repository and api based on their interfaces let us ignore the details of the implementations and 
explore all the possible routes in the class being tested. 
This makes the tests reusable and relay the heavy-duty testing of actual API calls to integration testing.

*/

/*
  To use mocking, you need to run
    flutter pub run build_runner build
  after you define the mocks. This will generate the mocking files for you.

  Mocking should be done on the interfaces (the Abstract classes).
  Because this is the cleanest way to test without worrying about the details of
  the implementations.
 */
@GenerateNiceMocks([MockSpec<AbstractAuthenticationSignInApi>()])
void main() {
  //  Logger.root.level = Level.ALL;
  // final Logger logger = Logger('login tests');
  // Logger.root.onRecord.listen((record) {
  //   print('${record.level.name}: ${record.message}');
  // });
  // logger.shout('test on how to use logger'); 

  //creating an instance of the class being mocked
  final MockAbstractAuthenticationSignInApi mockApi = MockAbstractAuthenticationSignInApi();

   // Define the response
  /*
  when(mock.function(is called with this input)).thenAnswer(this is what it will respond with)

  basically when a mock's function is called with specified input, it will return what's in thenAnswer to pretend the mock did the real thing
  */
  when(mockApi.signIn('abc@abc.com', '123456')).thenAnswer(
    (_) async => UserModel(
      id: 'e0bc4427-2286-4773-ba74-c4491ba5f1be',
      role: 'viewer',
    ));

  AuthenticationSignInRepositoryImpl authenticationSignInRepositoryImpl =
    AuthenticationSignInRepositoryImpl(api: mockApi); //passing the class we're testing the mock

  
  test('Test whether a valid user can sign in with AuthenticationSignInRepositoryImpl.signIn()',
    () async {

      // Test Case 1: This should log in successfully
      /*
      one of the lines in authenticationSignInRepositoryImpl.signIn is await _api.signIn(email, password);
      since we passed in the mock for api in the constructor for authenticationSignInRepositoryImpl, it will call mockApi.signIn instead
      so you will want the inputs to match a when() created earlier (you can have multiple when()s)
      */
      final Result authResult1 = await authenticationSignInRepositoryImpl.signIn('abc@abc.com', '123456'); 

      expect(authResult1.runtimeType, //(actual output, expected output) thnk of it as actual output == expected output {keep going} else{fail and leave test()} where 
          authentication_sign_in_result_classes.Success);
      if (authResult1 is authentication_sign_in_result_classes.Success) {
        expect(authResult1.userEntity.id, 'e0bc4427-2286-4773-ba74-c4491ba5f1be');
        expect(authResult1.userEntity.role, Role.viewer);

      } else { //this is another way to say the test() failed, expect will also do it, but this works if == is not how you compare (like when )
        fail('Expect authResult to be authentication_sign_in_result_classes.Success, but not true'); 
      }
    }
  );

  test('Test for a valid user with a wrong password can sign in with AuthenticationSignInRepositoryImpl.signIn()',
    () async {

      // Test Case 2: This should fail due to password miss match
      final Result authResult2 =
        await authenticationSignInRepositoryImpl.signIn('abc@abc.com', '1234567');
      if (authResult2 is authentication_sign_in_result_classes.Failure) {
        expect(authResult2.errorMessage, 'Login Failed');
      } else {
        fail('Expect authResult to be authentication_sign_in_result_classes.Failure, but not true');
      }

    }
  );

  test('Test whether a non-existant user can sign in with AuthenticationSignInRepositoryImpl.signIn()',
    () async {

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


  test('Test whether a user with an empty password can sign in with AuthenticationSignInRepositoryImpl.signIn()',
    () async {

      // Test Case 4: This should fail due to failing an assertion about acceptable password lengths
      final Result authResult3 =
        await authenticationSignInRepositoryImpl.signIn('abc@abc.com', '');
      if (authResult3 is! authentication_sign_in_result_classes.Failure) {
        fail('Expect authResult to be authentication_sign_in_result_classes.Failure, but not true');
      }
    }
  );

}