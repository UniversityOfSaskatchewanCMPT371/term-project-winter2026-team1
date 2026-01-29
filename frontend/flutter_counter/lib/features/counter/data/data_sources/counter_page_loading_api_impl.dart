import 'package:flutter_supabase_template/features/counter/data/data_sources/abstract_counter_page_loading_api.dart';
import 'package:flutter_supabase_template/features/counter/data/models/counter_model.dart';
import 'package:powersync/powersync.dart';
import 'package:powersync/sqlite3.dart';

class CounterPageLoadingApiImpl implements AbstractCounterPageLoadingApi {

  final PowerSyncDatabase _powerSyncDatabase;

  CounterPageLoadingApiImpl({required PowerSyncDatabase powerSyncDatabase}) :
        _powerSyncDatabase = powerSyncDatabase;

  @override
  Future<CounterModel> loadCounter() async {
    try {
      Row row = await _powerSyncDatabase.get('SELECT * FROM counters');
      CounterModel counterModel = CounterModel(
        id: row['id'],
        count: row['count'],
        ownerId: row['ownerId'],
        createdAt: DateTime.parse(row['createdAt']).toLocal(),
        modifiedAt: DateTime.parse(row['modifiedAt']).toLocal(),
      );
      return counterModel;
    } catch (e) {
      rethrow;
    }
  }
}