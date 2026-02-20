import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:search_cms/features/authentication/domain/repositories/abstract_authentication_sign_in_repository.dart';

import 'authentication_sign_in_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AbstractAuthenticationSignInRepository>()])
void main() {
  test('Test for the sign in function in AuthenticationSignInRepositoryImpl',
      () async {
        final MockAbstractAuthenticationSignInRepository mockRepository = MockAbstractAuthenticationSignInRepository();

      }
  );
}