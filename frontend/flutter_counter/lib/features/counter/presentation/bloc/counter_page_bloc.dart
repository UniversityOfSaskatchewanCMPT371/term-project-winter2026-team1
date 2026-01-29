import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_template/features/counter/domain/entities/counter_entity.dart';
import 'package:flutter_supabase_template/features/counter/domain/usecases/counter_page_use_cases.dart';
import 'package:flutter_supabase_template/utils/class_templates/result.dart';
import 'package:flutter_supabase_template/features/counter/domain/entities/counter_page_loading_result_classes.dart' as counter_page_loading_result_classes;

part 'counter_page_event.dart';
part 'counter_page_state.dart';

class CounterPageBloc extends Bloc<CounterPageEvent, CounterPageState> {

  final CounterPageUseCases counterPageUseCases;

  CounterPageBloc({required this.counterPageUseCases}) : super(CounterPageInitial()) {
    on<CounterPageLoadingStarted>(_handleLoading);
  }

  Future<void> _handleLoading(CounterPageEvent event, Emitter<CounterPageState> emit) async {
    emit(CounterPageLoadingInProgress());
    Result counterPageLoadingResult = await counterPageUseCases.counterPageLoadingUseCase.call();
    if (counterPageLoadingResult is counter_page_loading_result_classes.Success) {
      emit(CounterPageLoadingSuccess(counterEntity: counterPageLoadingResult.counterEntity));
    } else if (counterPageLoadingResult is counter_page_loading_result_classes.Failure) {
      emit(CounterPageLoadingFailure(errorMessage: counterPageLoadingResult.errorMessage));
    }
  }
}
