import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/constants.dart';
import '../models/area_model.dart';
import 'abstract_area_insert_api.dart';

// The api for inserting an area into Supabase
class AreaInsertApiImpl implements AbstractAreaInsertApi {

  // The Supabase client that is passed into this class
  final SupabaseClient _supabaseClient;

  /*
    The logger class we use to do logging.
    The question mark means it can be null.
    The reason is the logger can potentially leak information to hackers,
    so we set the project logging level to OFF so the logger is not constructed.
    The code before will check if logger is built and chooses not to log if
    there is no logger.
   */
  final Logger? _logger =
      logLevel != Level.OFF ? Logger('Area Insert Api') : null;

  AreaInsertApiImpl({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  /*
    The api function for inserting a new area into Supabase

    @param name A String containing the name of the area. Must not be empty.
    @return An AreaModel instance if insert is successful or null otherwise

    Preconditions: name.isNotEmpty
   */
  @override
  Future<AreaModel?> insertArea(String name) async {
    try {
      _logger?.finer('Area insert API start');

      // Assertion for the preconditions
      assert(name.isNotEmpty);

      final Map<String, dynamic> insertResult = await _supabaseClient
          .from('area')
          .insert({'name': name})
          .select()
          .single();

      _logger?.finest(insertResult);

      // Id should not be null after insert
      assert(insertResult['id'] != null);

      final AreaModel areaModel = AreaModel(
        id: insertResult['id'] as String,
        name: insertResult['name'] as String,
      );

      _logger?.finer('Area insert API end');

      return areaModel;
    } catch (e) {
      _logger?.shout(e);

      rethrow;
    }
  }
}
