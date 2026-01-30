import 'package:flutter_supabase_template/features/counter/domain/entities/counter_entity.dart';
import 'package:flutter_supabase_template/utils/class_templates/result.dart';

abstract class AbstractCounterPageIncrementAndUploadRepository {
  Future<Result> incrementAndUploadCounter(CounterEntity counterEntity);
}