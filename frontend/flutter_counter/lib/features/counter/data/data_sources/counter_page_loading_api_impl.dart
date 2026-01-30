import 'package:flutter_supabase_template/features/counter/data/data_sources/abstract_counter_page_loading_api.dart';
import 'package:flutter_supabase_template/features/counter/data/models/counter_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CounterPageLoadingApiImpl implements AbstractCounterPageLoadingApi {

  final SupabaseClient _supabaseClient;

  CounterPageLoadingApiImpl({required SupabaseClient supabaseClient}) :
        _supabaseClient = supabaseClient;


  @override
  Future<CounterModel> loadCounter() async {
    try {
      final PostgrestList queryResult = await _supabaseClient
          .from('counters')
          .select();
      CounterModel counterModel = CounterModel(
        id: queryResult[0]['id'],
        count: queryResult[0]['count'],
        ownerId: queryResult[0]['owner_id'],
        createdAt: DateTime.parse(queryResult[0]['created_at']).toLocal(),
        modifiedAt: DateTime.parse(queryResult[0]['modified_at']).toLocal(),
      );
      return counterModel;
    } catch (e) {
      rethrow;
    }
  }
}