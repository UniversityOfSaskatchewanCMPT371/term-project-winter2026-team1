import '../../../../core/utils/class_templates/result.dart';
import 'user_entity.dart';

/*
  Success is a child class of Result. This utilises polymorphism to signal the
  call from usecase is success.

  @param userEntity A UserEntity class that contains the user id and the user
    role
 */
class Success extends Result {
  final UserEntity userEntity;

  Success({required this.userEntity});
}

/*
  Failure is a child class of Result. This utilises polymorphism to signal the
  call from usecase is failure.

  @param errorMessage The error message from the api call
 */
class Failure extends Result {
  final String errorMessage;

  Failure({required this.errorMessage});
}