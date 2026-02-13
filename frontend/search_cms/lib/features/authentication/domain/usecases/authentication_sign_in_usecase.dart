import '../../../../core/utils/class_templates/result.dart';
import '../repositories/abstract_authentication_sign_in_repository.dart';

class AuthenticationSignInUsecase {
  final AbstractAuthenticationSignInRepository repository;

  AuthenticationSignInUsecase({required this.repository});

  Future<Result> call(String email, String password) async {
    Result result = await repository.signIn(email, password);
    return result;
  }
}