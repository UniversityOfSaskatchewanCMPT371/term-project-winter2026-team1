import 'package:powersync/powersync.dart';

// Read the tables
const sitesTable = 'site';
const areasTable = 'area';
const siteAreasTable = 'site_area';
const unitsTable = 'unit';
const levelsTable = 'level';

const schema = Schema([
  Table(sitesTable, [
    Column.text('id'), // Uniquely generated ID (UUID)
    Column.text('name'), // The name of a site. This can be empty
    Column.text('borden'), // The Borden, which is like the name
    Column.text('created_at'), // When a site was created
    Column.text('updated_at'), // When was data last updated
  ]),

  Table(areasTable, [
    Column.text('id'), // Uniquely generated ID (UUID)
    Column.text('name'), // The name of an area
    Column.text('created_at'), // When an area was created
    Column.text('updated_at'), // When was data last updated
  ]),

  // An intermediate table. Takes site_id and area_id as PKs
  Table(siteAreasTable, [
    Column.text('site_id'),
    Column.text('area_id'),
  ]),

  Table(unitsTable, [
    Column.text('id'), // Uniquely generated ID (UUID)
    Column.text('site_id'), // A site can have multiple units
    Column.text('name'), // The name of a unit
    Column.text('created_at'), // When a unit was created
    Column.text('updated_at'), // When was data last updated
  ]),
  
  Table(levelsTable, [
    Column.text('id'), // Uniquely generated ID (UUID)
    Column.text('unit_id'), // A unit can have multiple levels.
    Column.text('parent_id'), //The top-most level in a unit can't have a parent
    Column.text('name'), // The name of a level
    Column.integer('up_limit'), // Depth in cm
    Column.integer('low_limit'), // Depth in cm
    Column.text('created_at'), // When a level was created
    Column.text('updated_at'), // When was data last updated
    Column.text('level_char'), // Some other arch data
    Column.integer('level_int'), // Some other arch data
  ]),
]);


