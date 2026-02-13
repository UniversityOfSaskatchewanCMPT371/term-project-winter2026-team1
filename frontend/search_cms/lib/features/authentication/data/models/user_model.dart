import '../../domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final Role role;

  UserModel({
    required this.id,
    required this.role,
  });
}