import '../../../../core/utils/class_templates/result.dart';

abstract class AbstractAuthenticationSignInRepository {
  Future<Result> signIn(String email, String password);
}