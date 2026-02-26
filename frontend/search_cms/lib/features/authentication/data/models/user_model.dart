/*
  The user model for the authentication and role management.

  @param id The uuid for the user
  @param role The string for the role of the user. Current possible values are
  "viewer", "admin", "researcher"
 */
class UserModel {
  final String id;
  final String role;

  UserModel({
    required this.id,
    required this.role,
  });
}