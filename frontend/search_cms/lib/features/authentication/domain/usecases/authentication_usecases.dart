import 'authentication_sign_in_usecase.dart';

/*
  The collection of all use cases for the authentication feature.

  @param authenticationSignInUsecase The constructed authentication sign in
    use case pass in to the constructor for this class
 */
class AuthenticationUsecases {
  final AuthenticationSignInUsecase authenticationSignInUsecase;

  AuthenticationUsecases({
    required this.authenticationSignInUsecase,
  });
}