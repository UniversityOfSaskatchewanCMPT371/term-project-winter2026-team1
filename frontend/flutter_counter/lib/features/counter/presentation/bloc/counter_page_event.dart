part of 'counter_page_bloc.dart';

sealed class CounterPageEvent extends Equatable {
  const CounterPageEvent();
}

final class CounterPageLoadingStarted extends CounterPageEvent {
  @override
  List<Object?> get props => [];
}

final class CounterPageIncrementAndUploadStarted extends CounterPageEvent {

  final CounterEntity counterEntity;

  const CounterPageIncrementAndUploadStarted({required this.counterEntity});

  @override
  List<Object?> get props => [counterEntity];
}