import 'package:flutter_supabase_template/core/utils/class_templates/result.dart';

abstract class AbstractCounterPageLoadingRepository {
  Future<Result> loadCounter();
}