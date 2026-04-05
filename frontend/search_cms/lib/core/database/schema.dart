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

  // An intermediate table linking site and area
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
    Column.text('unit_id'), // A unit can have multiple levels
    Column.text('parent_id'), //The top-most level in a unit can't have a parent
    Column.text('name'), // The name of a level
    Column.integer('up_limit'), // Depth in cm
    Column.integer('low_limit'), // Depth in cm
    Column.text('created_at'), // When a level was created
    Column.text('updated_at'), // When was data last updated
    Column.text('level_char'), // Some other arch data
    Column.integer('level_int'), // Some other arch data
  ]),

  Table('assemblage', [
    Column.text('level_id'), // A level can have multiple assemblages
    Column.text('name'), // The name of an assemblage. This can be empty by default
    Column.text('created_at'), // When an assemblage was created
    Column.text('updated_at'), // When was data last updated
  ]),

  Table('artifact_faunal', [
    Column.text('assemblage_id'), // An assemblage can have multiple artifacts
    Column.integer('porosity'), // The porosity of an artifact. Must be between 1-5
    Column.real('size_upper'), // Upper size of an artifact in mm/cm
    Column.real('size_lower'), // Lower size of an artifact in mm/cm
    Column.text('comment'), // Any additional comments about an artifact. This can be empty
    Column.integer('pre_excav_frags'), // Pre-excavation fragments. This will be set to 1 by default
    Column.integer('post_excav_frags'), // Post-excavation fragments. This will be set to 1 by default
    Column.integer('elements'), // Number of elements in an artifact. This will be set to 1 by default
    Column.text('created_at'), // When an artifact was created
    Column.text('updated_at'), // When was data last updated
  ]),

  Table('role', [
    Column.text('created_at'), // When a role was created
    Column.text('role'), // Either 'admin', 'researcher', or 'viewer'
  ]),
]);



