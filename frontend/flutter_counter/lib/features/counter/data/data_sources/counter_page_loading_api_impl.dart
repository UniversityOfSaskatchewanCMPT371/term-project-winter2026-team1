import 'package:flutter_supabase_template/features/counter/data/data_sources/abstract_counter_page_loading_api.dart';
import 'package:flutter_supabase_template/features/counter/data/models/counter_model.dart';
import 'package:powersync/powersync.dart' show PowerSyncDatabase;

class CounterPageLoadingApiImpl implements AbstractCounterPageLoadingApi {

  final PowerSyncDatabase _powerSyncDatabase;

  CounterPageLoadingApiImpl({required PowerSyncDatabase powerSyncDatabase}) : _powerSyncDatabase = powerSyncDatabase;


  @override
  Future<CounterModel> loadCounter() async {
    try {
      final result = await _powerSyncDatabase.get('SELECT * FROM counters');
      CounterModel counterModel = CounterModel(
        id: result['id'],
        count: result['count'],
        ownerId: result['owner_id'],
        createdAt: DateTime.parse(result['created_at']),
        modifiedAt: DateTime.parse(result['modified_at']).toLocal(),
      );
      return counterModel;
    } catch (e) {
      rethrow;
    }
  }
}