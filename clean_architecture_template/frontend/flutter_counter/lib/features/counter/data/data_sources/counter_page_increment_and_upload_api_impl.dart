import 'package:flutter_supabase_template/features/counter/data/data_sources/abstract_counter_page_increment_and_upload_api.dart';
import 'package:flutter_supabase_template/features/counter/data/models/counter_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show SupabaseClient;

class CounterPageIncrementAndUploadApiImpl implements AbstractCounterPageIncrementAndUploadApi {

  final SupabaseClient _supabaseClient;

  CounterPageIncrementAndUploadApiImpl({required SupabaseClient supabaseClient}) : _supabaseClient = supabaseClient;

  @override
  Future<bool> incrementAndUploadCounter(CounterModel counterModel) async {
    try {
      await _supabaseClient.from('counters').
        update({
        'count' : counterModel.count,
        'modified_at' : counterModel.modifiedAt.toIso8601String()})
          .eq('id', counterModel.id);
      return true;
    } catch (e) {
      rethrow;
    }
  }
}