import 'package:flutter_supabase_template/features/counter/data/models/counter_model.dart';

abstract class AbstractCounterPageLoadingApi {
  Future<CounterModel> loadCounter();
}