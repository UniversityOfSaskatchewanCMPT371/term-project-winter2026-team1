part of 'counter_page_bloc.dart';

sealed class CounterPageState extends Equatable {
  const CounterPageState();
}

final class CounterPageInitial extends CounterPageState {
  @override
  List<Object> get props => [];
}

final class CounterPageLoadingInProgress extends CounterPageState {
  @override
  List<Object?> get props => [];
}

final class CounterPageLoadingSuccess extends CounterPageState {
  final CounterEntity counterEntity;

  const CounterPageLoadingSuccess({required this.counterEntity});

  @override
  List<Object?> get props => [counterEntity];
}

final class CounterPageLoadingFailure extends CounterPageState {
  final String errorMessage;

  const CounterPageLoadingFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}