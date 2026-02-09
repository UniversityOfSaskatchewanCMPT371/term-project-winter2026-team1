import 'package:flutter_supabase_template/features/counter/data/data_sources/abstract_counter_page_increment_and_upload_api.dart';
import 'package:flutter_supabase_template/features/counter/data/models/counter_model.dart';
import 'package:powersync/powersync.dart';

class CounterPageIncrementAndUploadApiImpl implements AbstractCounterPageIncrementAndUploadApi {

  final PowerSyncDatabase _powerSyncDatabase;

  CounterPageIncrementAndUploadApiImpl({required PowerSyncDatabase powerSyncDatabase}) : _powerSyncDatabase = powerSyncDatabase;

  @override
  Future<bool> incrementAndUploadCounter(CounterModel counterModel) async {
    try {
      await _powerSyncDatabase.execute('UPDATE counters SET count = ?, modified_at = ? WHERE id = ?;',
          [counterModel.count, counterModel.modifiedAt.toIso8601String(), counterModel.id]
      );
      return true;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}