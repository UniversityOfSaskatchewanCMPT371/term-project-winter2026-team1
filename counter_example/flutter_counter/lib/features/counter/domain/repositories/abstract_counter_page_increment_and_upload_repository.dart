import 'package:flutter_supabase_template/core/utils/class_templates/result.dart';
import 'package:flutter_supabase_template/features/counter/domain/entities/counter_entity.dart';

abstract class AbstractCounterPageIncrementAndUploadRepository {
  Future<Result> incrementAndUploadCounter(CounterEntity counterEntity);
}