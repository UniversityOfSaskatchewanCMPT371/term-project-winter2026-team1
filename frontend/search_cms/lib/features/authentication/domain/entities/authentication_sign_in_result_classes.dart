import '../../../../core/utils/class_templates/result.dart';
import 'user_entity.dart';

class Success extends Result {
  final UserEntity userEntity;

  Success({required this.userEntity});
}

class Failure extends Result {
  final String errorMessage;

  Failure({required this.errorMessage});
}