import 'package:powersync/powersync.dart';

const schema = Schema([
  Table('site', [
    Column.text('name'), // The name of a site. This can be empty
    Column.text('borden'), // The Borden, which is like the name
    Column.text('created_at'), // When a site was created
    Column.text('updated_at'), // When was data last updated
  ]),

  Table('area', [
    Column.text('name'), // The name of an area
    Column.text('created_at'), // When an area was created
    Column.text('updated_at'), // When was data last updated
  ]),

  // An intermediate table. Takes site_id and area_id as PKs
  Table('site_area', [
    Column.text('site_id'),
    Column.text('area_id'),
  ]),

  Table('unit', [
    Column.text('site_id'), // A site can have multiple units
    Column.text('name'), // The name of a unit
    Column.text('created_at'), // When a unit was created
    Column.text('updated_at'), // When was data last updated
  ]),
  
  Table('level', [
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


