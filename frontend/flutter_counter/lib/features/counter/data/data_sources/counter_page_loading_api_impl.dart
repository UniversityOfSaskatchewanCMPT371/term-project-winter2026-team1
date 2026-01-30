import 'package:flutter_supabase_template/features/counter/data/data_sources/abstract_counter_page_loading_api.dart';
import 'package:flutter_supabase_template/features/counter/data/models/counter_model.dart';
import 'package:powersync/powersync.dart';

class CounterPageLoadingApiImpl implements AbstractCounterPageLoadingApi {

  final PowerSyncDatabase _powerSyncDatabase;

  CounterPageLoadingApiImpl({required PowerSyncDatabase powerSyncDatabase}) :
        _powerSyncDatabase = powerSyncDatabase;

  @override
  Future<CounterModel> loadCounter() async {
    try {
      var row = await _powerSyncDatabase.get('SELECT * FROM counters');
      CounterModel counterModel = CounterModel(
        id: row['id'],
        count: row['count'],
        ownerId: row['owner_id'],
        createdAt: DateTime.parse(row['created_at']).toLocal(),
        modifiedAt: DateTime.parse(row['modified_at']).toLocal(),
      );
      return counterModel;
    } catch (e) {
      rethrow;
    }
  }
}