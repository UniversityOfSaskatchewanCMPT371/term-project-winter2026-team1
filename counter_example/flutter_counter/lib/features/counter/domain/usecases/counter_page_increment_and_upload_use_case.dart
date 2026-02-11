import 'package:flutter_supabase_template/core/utils/class_templates/result.dart';
import 'package:flutter_supabase_template/features/counter/domain/entities/counter_entity.dart';
import 'package:flutter_supabase_template/features/counter/domain/repositories/abstract_counter_page_increment_and_upload_repository.dart';

class CounterPageIncrementAndUploadUseCase {
  final AbstractCounterPageIncrementAndUploadRepository _repository;

  CounterPageIncrementAndUploadUseCase({
    required AbstractCounterPageIncrementAndUploadRepository repository}) :
        _repository = repository;

  Future<Result> call(CounterEntity counterEntity) async {
    CounterEntity newCounterEntity = _increment(counterEntity);
    Result result = await _repository.incrementAndUploadCounter(newCounterEntity);
    return result;
  }

  CounterEntity _increment(CounterEntity counterEntity) {

    int newCount = counterEntity.count + 1;
    DateTime newModifiedAt = DateTime.now();

    return CounterEntity(
      id: counterEntity.id,
      count: newCount,
      ownerId: counterEntity.ownerId,
      createdAt: counterEntity.createdAt,
      modifiedAt: newModifiedAt
    );
  }
}