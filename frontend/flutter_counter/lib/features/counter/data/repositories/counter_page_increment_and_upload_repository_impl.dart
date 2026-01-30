import 'package:flutter_supabase_template/features/counter/data/data_sources/abstract_counter_page_increment_and_upload_api.dart';
import 'package:flutter_supabase_template/features/counter/data/models/counter_model.dart';
import 'package:flutter_supabase_template/features/counter/domain/entities/counter_entity.dart';
import 'package:flutter_supabase_template/features/counter/domain/repositories/abstract_counter_page_increment_and_upload_repository.dart';
import 'package:flutter_supabase_template/utils/class_templates/result.dart';
import 'package:flutter_supabase_template/features/counter/domain/entities/counter_page_increment_and_upload_result_classes.dart' as counter_page_increment_and_upload_result_classes;

class CounterPageIncrementAndUploadRepositoryImpl implements AbstractCounterPageIncrementAndUploadRepository {

  final AbstractCounterPageIncrementAndUploadApi _api;

  CounterPageIncrementAndUploadRepositoryImpl({
    required AbstractCounterPageIncrementAndUploadApi api}) : _api = api;

  @override
  Future<Result> incrementAndUploadCounter(CounterEntity counterEntity) async {
    try {
      CounterModel counterModel = CounterModel(
        id: counterEntity.id,
        count: counterEntity.count,
        ownerId: counterEntity.ownerId,
        createdAt: counterEntity.createdAt,
        modifiedAt: counterEntity.modifiedAt
      );
      bool isSuccessful = await _api.incrementAndUploadCounter(counterModel);
      if (isSuccessful) {
        return counter_page_increment_and_upload_result_classes.Success();
      } else {
        return counter_page_increment_and_upload_result_classes.Failure(errorMessage: 'Failed to increment and upload');
      }
    } catch (e) {
      return counter_page_increment_and_upload_result_classes.Failure(errorMessage: e.toString());
    }
  }
}