import 'package:powersync/sqlite3_common.dart' as sqlite;
import 'package:search_cms/features/authentication/domain/entities/site_area_entity.dart';

/*
  Data-layer model responsible for mapping PowerSync SQLite row.
*/

class SiteAreaModel {
  final String siteId;
  final String areaId;

  SiteAreaModel({
    required this.siteId,
    required this.areaId,
  });

  // Map SiteAreaEntity instead of inheriting it to prevent coupling and proper separation
  SiteAreaEntity toEntity() {
    return SiteAreaEntity(
      siteId: siteId,
      areaId: areaId,
    );
  }

  /*
    Creates a SiteAreaModel from a PowerSync SQLite row.

    Preconditions:
    - Row must contain: 'site_id', 'area_id'

    Postconditions:
    - Returns a SiteAreaModel
    - Ensures invariants are satisfied before creating the model

    Throws a FormatException if required columns are missing.
  */
  factory SiteAreaModel.fromRow(sqlite.Row row) {

    // Extract raw dynamic values from PowerSync row
    final dynamic siteIdRaw = row['site_id'];
    final dynamic areaIdRaw = row['area_id'];

    // check if anything is null. If so, throw an exception
    if (siteIdRaw == null || areaIdRaw == null) {
      throw FormatException('Missing required column(s)');
    }

    // convert raw values from PowerSync rows
    final String siteId = siteIdRaw.toString();
    final String areaId = areaIdRaw.toString();

    assert(siteId.isNotEmpty, 'Site ID cannot be empty');
    assert(areaId.isNotEmpty, 'Area ID cannot be empty');

    return SiteAreaModel(
      siteId: siteId,
      areaId: areaId,
    );
  }
}