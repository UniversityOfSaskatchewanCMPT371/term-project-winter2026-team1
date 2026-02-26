enum Role {
  admin,
  researcher,
  viewer,
}

class UserEntity {
  final String id;
  final Role role;

  UserEntity({
    required this.id,
    required this.role,
  });
}