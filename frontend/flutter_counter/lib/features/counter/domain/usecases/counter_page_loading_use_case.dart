import 'package:flutter_supabase_template/features/counter/domain/repositories/absract_counter_page_loading_repository.dart';
import 'package:flutter_supabase_template/utils/class_templates/result.dart';

class CounterPageLoadingUseCase  {
  final AbstractCounterPageLoadingRepository _repository;

  CounterPageLoadingUseCase({required AbstractCounterPageLoadingRepository repository})
      : _repository = repository;

  Future<Result> call() async {
    Result result = await _repository.loadCounter();
    return result;
  }
}