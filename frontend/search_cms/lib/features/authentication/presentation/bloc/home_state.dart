import 'package:equatable/equatable.dart';

/*
  The states for the UI

  The get Props method is the feature of Equatable.
  If the provided parameters are the same, then the newly triggered state would
  be deemed as equal and will not trigger a UI rebuild
 */
sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

// The original home page state
class HomeInitial extends HomeState {
  const HomeInitial();
}

// The loading state
class HomeLoading extends HomeState {
  const HomeLoading();
}

/*
  The home success state
  @param user The user entity class contains the user id and user role
 */
class HomeSuccess extends HomeState {

  const HomeSuccess();

  @override
  List<Object?> get props => [];
}

/*
  The home failure state

  @param message The error message string
 */
class HomeFailure extends HomeState {
  final String message;

  const HomeFailure(this.message);

  @override
  List<Object?> get props => [message];
}
