part of 'counter_page_bloc.dart';

sealed class CounterPageEvent extends Equatable {
  const CounterPageEvent();
}

final class CounterPageLoadingStarted extends CounterPageEvent {
  @override
  List<Object?> get props => [];
}

final class CounterPageIncrementAndUploadStarted extends CounterPageEvent {

  final int count;

  const CounterPageIncrementAndUploadStarted({required this.count});

  @override
  List<Object?> get props => [count];
}