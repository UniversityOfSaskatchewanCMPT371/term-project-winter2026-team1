import 'package:powersync/powersync.dart';

import '../../../../core/database/schema.dart';
import 'abstract_dashboard_api.dart';
import '../models/area_model.dart';
import '../models/level_model.dart';
import '../models/site_area_model.dart';
import '../models/site_model.dart';
import '../models/unit_model.dart';

/*
  The api implementation for the dashboard feature
*/
// (TODO) implement these functions
class DashboardApiImpl implements AbstractDashboardApi {

  final PowerSyncDatabase database;

  DashboardApiImpl({required this.database});

  /*
    Retrieves all Site records from the database

    @return A list containing all SiteModel objects currently stored
      if no sites exist an empty list is returned

    Preconditions: database connection must be available
  */
  @override
  Future<List<SiteModel>> getAllSites() async {
    throw UnimplementedError();
  }

  /*
    Retrieves all Area records from the database

    @return A list containing all AreaModel objects currently stored
      if no areas exist an empty list is returned

    Preconditions: database connection must be available
  */
  @override
  Future<List<AreaModel>> getAllAreas() async {
    throw UnimplementedError();
  }

  /*
    Retrieves all SiteArea relationship records

    @return A list containing all SiteAreaModel objects currently stored
      if no site areas exist an empty list is returned

    Preconditions: database connection must be available
  */
  @override
  Future<List<SiteAreaModel>> getAllSiteAreas() async {
    throw UnimplementedError();
  }

  /*
    Retrieves all Unit records from the database

    @return A list containing all UnitModel objects currently stored
      if no units exist an empty list is returned

    Preconditions: database connection must be available
  */
  @override
  Future<List<UnitModel>> getAllUnits() async {
    throw UnimplementedError();
  }

  /*
    Retrieves all Level records from the database

    @return A list containing all LevelModel objects currently stored,
      if no levels exist an empty list is returned

    Preconditions: database connection must be available
  */
  @override
  Future<List<LevelModel>> getAllLevels() async {
    throw UnimplementedError();
  }

  /*
    Performs the basic dashboard search.

    For the initial implementation we fetch the currently implemented tables
    and filter them in Dart.
  */
  @override
  Future<List<List<String>>> basicSearch(String query) async {

    final normalizedQuery = query.trim().toLowerCase();

    final sites = await _readTable(sitesTable);
    final areas = await _readTable(areasTable);
    final units = await _readTable(unitsTable);
    final levels = await _readTable(levelsTable);

    final List<List<String>> rows = [];

    // Search sites
    for (final site in sites) {
      final name = _stringValue(site['name']);
      final borden = _stringValue(site['borden']);

      if (_matchesQuery(normalizedQuery, [name, borden])) {
        rows.add([
          name.isNotEmpty ? name : borden,
          borden,
          '',
          ''
        ]);
      }
    }

    // Search areas
    for (final area in areas) {
      final name = _stringValue(area['name']);

      if (_matchesQuery(normalizedQuery, [name])) {
        rows.add([
          name,
          '',
          '',
          ''
        ]);
      }
    }

    // Search units
    for (final unit in units) {
      final name = _stringValue(unit['name']);

      if (_matchesQuery(normalizedQuery, [name])) {
        rows.add([
          name,
          '',
          name,
          ''
        ]);
      }
    }

    // Search levels
    for (final level in levels) {
      final name = _stringValue(level['name']);
      final levelChar = _stringValue(level['level_char']);
      final levelInt = _stringValue(level['level_int']);

      if (_matchesQuery(normalizedQuery, [name, levelChar, levelInt])) {
        rows.add([
          name,
          '',
          '',
          name
        ]);
      }
    }

    rows.sort((a, b) => a[0].compareTo(b[0]));

    return rows;
  }

  Future<List<Map<String, dynamic>>> _readTable(String tableName) async {

    final result = await database.getAll('SELECT * FROM $tableName');

    return result.map<Map<String, dynamic>>(
      (row) => Map<String, dynamic>.from(row as Map),
    ).toList();
  }

  bool _matchesQuery(String query, List<String> values) {

    if (query.isEmpty) {
      return true;
    }

    for (final value in values) {
      if (value.toLowerCase().contains(query)) {
        return true;
      }
    }

    return false;
  }

  String _stringValue(dynamic value) {
    if (value == null) {
      return '';
    }
    return value.toString().trim();
  }

  /*
    Creates a new Site record in the database
  */
  @override
  Future<void> createSite({
    required String borden,
    String? name,
  }) async {
    throw UnimplementedError();
  }

  /*
    Creates a new Area record in the database
  */
  @override
  Future<void> createArea({
    required String name,
  }) async {
    throw UnimplementedError();
  }

  /*
    Creates a new SiteArea record in the database
  */
  @override
  Future<void> createSiteArea({
    required String siteId,
    required String areaId,
  }) async {
    throw UnimplementedError();
  }

  /*
    Creates a new Unit record in the database
  */
  @override
  Future<void> createUnit({
    required String siteId,
    required String name,
  }) async {
    throw UnimplementedError();
  }

  /*
    Creates a new Level record in the database
  */
  @override
  Future<void> createLevel({
    required String unitId,
    required String name,
    required int upLimit,
    required int lowLimit,
    String? parentId,
    String? levelChar,
    int? levelInt
  }) async {
    throw UnimplementedError();
  }
}