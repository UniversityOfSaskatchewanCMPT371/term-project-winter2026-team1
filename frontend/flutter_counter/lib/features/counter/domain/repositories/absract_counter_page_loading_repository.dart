import 'package:flutter_supabase_template/utils/class_templates/result.dart';

abstract class AbstractCounterPageLoadingRepository {
  Future<Result> loadCounter();
}