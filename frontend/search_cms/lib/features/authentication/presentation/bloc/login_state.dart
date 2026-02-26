import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

/*
  The states for the UI

  The get Props method is the feature of Equatable.
  If the provided parameters are the same, then the newly triggered state would
  be deemed as equal and will not trigger a UI rebuild
 */
sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

// The original login page state
class LoginInitial extends LoginState {
  const LoginInitial();
}

// The loading state
class LoginLoading extends LoginState {
  const LoginLoading();
}

/*
  The login success state

  @param user The user entity class contains the user id and user role
 */
class LoginSuccess extends LoginState {
  final UserEntity user;

  const LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

/*
  The login failure state

  @param message The error message string
 */
class LoginFailure extends LoginState {
  final String message;

  const LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}
