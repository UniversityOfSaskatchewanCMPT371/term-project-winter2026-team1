import 'package:logging/logging.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/authentication/data/data_sources/abstract_authentication_sign_in_api.dart';
import 'package:search_cms/features/authentication/data/models/user_model.dart';
import 'package:search_cms/features/authentication/domain/entities/user_entity.dart';
import '../../../../core/utils/class_templates/result.dart';
import '../../domain/repositories/abstract_authentication_sign_in_repository.dart';
import '../../domain/entities/authentication_sign_in_result_classes.dart'
    as authentication_sign_in_result_classes;

/*
  The repository implementation for signing in with email and password to
  Supabase
 */

class AuthenticationSignInRepositoryImpl
    implements AbstractAuthenticationSignInRepository {
  /*
    This is the interface for the api for sign in. We will pass in the
    actual implementation for the api here.
   */
  final AbstractAuthenticationSignInApi _api;
  final Logger? _logger = logLevel != Level.OFF
      ? Logger('Authentication Sign In Repository')
      : null;

  AuthenticationSignInRepositoryImpl({
    required AbstractAuthenticationSignInApi api,
  }) : _api = api;

/*
  The repository function for signing in with email and password to Supabase

  @param email A String containing a valid email address
  @param password A String containing a password with a length not shorter than 6
    and not longer than 72
  @return A Success if login is successful, containing the UserEntity or
    Failure containing the errorMessage otherwise

  Preconditions: password.length >= 6 && password.length <= 72
  Postconditions: A Result children class Success or Failure will be returned
*/
  @override
  Future<Result> signIn(String email, String password) async {
    try {
      _logger?.finer('Authentication sign in repository start');

      // Assertion for the preconditions
      assert(password.length >= 6 && password.length <= 72);

      // If there is user returned, then sign in is successful. Null otherwise.
      UserModel? userModel = await _api.signIn(email, password);
      if (userModel != null) {
        final Role role;

        // The role can only be these three options
        assert(
          userModel.role == 'admin' ||
              userModel.role == 'researcher' ||
              userModel.role == 'viewer',
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
          userEntity: UserEntity(id: userModel.id, role: role),
        );
      } else {
        return authentication_sign_in_result_classes.Failure(
          errorMessage: 'Login Failed',
        );
      }
    } catch (e) {
      return authentication_sign_in_result_classes.Failure(
        errorMessage: e.toString(),
      );
    }
  }
}
