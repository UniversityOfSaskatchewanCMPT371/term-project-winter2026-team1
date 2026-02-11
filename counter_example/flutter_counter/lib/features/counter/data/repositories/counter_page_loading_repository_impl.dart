import 'package:flutter_supabase_template/core/utils/class_templates/result.dart';
import 'package:flutter_supabase_template/features/counter/data/data_sources/abstract_counter_page_loading_api.dart';
import 'package:flutter_supabase_template/features/counter/data/models/counter_model.dart';
import 'package:flutter_supabase_template/features/counter/domain/entities/counter_entity.dart';
import 'package:flutter_supabase_template/features/counter/domain/entities/counter_page_loading_result_classes.dart';


import '../../domain/repositories/absract_counter_page_loading_repository.dart';

class CounterPageLoadingRepositoryImpl implements AbstractCounterPageLoadingRepository {

  final AbstractCounterPageLoadingApi _api;

  CounterPageLoadingRepositoryImpl({required AbstractCounterPageLoadingApi api}) : _api = api;

  @override
  Future<Result> loadCounter() async {
    try {
      CounterModel counterModel = await _api.loadCounter();
      CounterEntity counterEntity = CounterEntity(
        id: counterModel.id,
        count: counterModel.count,
        ownerId: counterModel.ownerId,
        createdAt: counterModel.createdAt,
        modifiedAt: counterModel.modifiedAt
      );
      return Success(counterEntity: counterEntity);
    } catch (e) {
      return Failure(errorMessage: e.toString());
    }
  }
}