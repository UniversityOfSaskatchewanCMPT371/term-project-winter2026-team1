import '../models/counter_model.dart';

abstract class AbstractCounterPageIncrementAndUploadApi {
  Future<bool> incrementAndUploadCounter(CounterModel counterModel);
}