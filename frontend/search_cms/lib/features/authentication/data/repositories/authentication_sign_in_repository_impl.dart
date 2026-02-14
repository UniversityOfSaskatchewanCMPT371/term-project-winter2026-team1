import 'package:logging/logging.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/authentication/data/data_sources/authentication_sign_in_api_impl.dart';
import 'package:search_cms/features/authentication/data/models/user_model.dart';
import 'package:search_cms/features/authentication/domain/entities/user_entity.dart';
import '../../../../core/utils/class_templates/result.dart';
import '../../domain/repositories/abstract_authentication_sign_in_repository.dart';
import '../../domain/entities/authentication_sign_in_result_classes.dart' as authentication_sign_in_result_classes;


class AuthenticationSignInRepositoryImpl implements AbstractAuthenticationSignInRepository {

  final AuthenticationSignInApiImpl api;
  final Logger? logger =
    logLevel != Level.OFF ? Logger('Authentication Sign In Repository') : null;

  AuthenticationSignInRepositoryImpl({required this.api});

  /*
    The repository function for signing in with email and password to Suapabase
   */
  @override
  Future<Result> signIn(String email, String password) async {
    try {
      logger?.finer('Authentication sign in repository start');

      // Assertion for the preconditions
      assert(password.length >= 6 && password.length <= 72);

      UserModel? userModel = await api.signIn(email, password);
      if (userModel != null) {

        final Role role;

        assert(userModel.role == 'admin' ||
            userModel.role == 'researcher' ||
            userModel.role == 'viewer'
        );

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