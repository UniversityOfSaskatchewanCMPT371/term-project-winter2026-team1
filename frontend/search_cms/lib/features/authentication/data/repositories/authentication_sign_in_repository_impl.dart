import 'package:search_cms/features/authentication/data/data_sources/authentication_sign_in_api_impl.dart';
import 'package:search_cms/features/authentication/data/models/user_model.dart';
import 'package:search_cms/features/authentication/domain/entities/user_entity.dart';
import '../../../../core/utils/class_templates/result.dart';
import '../../domain/repositories/abstract_authentication_sign_in_repository.dart';
import '../../domain/entities/authentication_sign_in_result_classes.dart' as authentication_sign_in_result_classes;

class AuthenticationSignInRepositoryImpl implements AbstractAuthenticationSignInRepository {

  final AuthenticationSignInApiImpl api;

  AuthenticationSignInRepositoryImpl({required this.api});

  @override
  Future<Result> signIn(String email, String password) async {
    try {
      UserModel? userModel = await api.signIn(email, password);
      if (userModel != null) {

        final Role role;

        switch (userModel.role) {
          case 'admin':
            role = Role.admin;
          case 'researcher':
            role = Role.researcher;
          case 'viewer':
            role = Role.viewer;
          default:
            role = Role.viewer;
        }

        return authentication_sign_in_result_classes.Success(
            userEntity: UserEntity(
              id: userModel.id,
              role: role,
            )
        );
      } else {
        return authentication_sign_in_result_classes.Failure(errorMessage: 'Login Failed');
      }
    } catch (e) {
      return authentication_sign_in_result_classes.Failure(errorMessage: e.toString());
    }
  }
}