import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/constants.dart';
import '../models/site_model.dart';
import 'abstract_site_insert_api.dart';

// The api for inserting a site into Supabase
class SiteInsertApiImpl implements AbstractSiteInsertApi {

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
      logLevel != Level.OFF ? Logger('Site Insert Api') : null;

  SiteInsertApiImpl({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  /*
    The api function for inserting a new site into Supabase

    @param name A String containing the name of the site. Can be empty.
    @param borden A String containing the Borden classification code.
      Max 8 characters and must be unique.
    @return A SiteModel instance if insert is successful or null otherwise

    Preconditions: borden.length <= 8 && borden.isNotEmpty
   */
  @override
  Future<SiteModel?> insertSite(String name, String borden) async {
    try {
      _logger?.finer('Site insert API start');

      // Assertion for the preconditions
      assert(borden.isNotEmpty && borden.length <= 8);

      final Map<String, dynamic> insertResult = await _supabaseClient
          .from('site')
          .insert({'name': name, 'borden': borden})
          .select()
          .single();

      _logger?.finest(insertResult);

      // Id should not be null after insert
      assert(insertResult['id'] != null);

      final SiteModel siteModel = SiteModel(
        id: insertResult['id'] as String,
        name: insertResult['name'] as String,
        borden: insertResult['borden'] as String,
      );

      _logger?.finer('Site insert API end');

      return siteModel;
    } catch (e) {
      _logger?.shout(e);

      rethrow;
    }
  }
}
