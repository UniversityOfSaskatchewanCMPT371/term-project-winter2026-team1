import 'package:powersync/powersync.dart';

const sitesTable = 'site';
const areasTable = 'area';
const siteAreasTable = 'site_area';
const unitsTable = 'unit';
const levelsTable = 'level';

const schema = Schema([
  Table(sitesTable, [
    Column.text('id'),
    Column.text('name'),
    Column.text('borden'),
    Column.text('created_at'),
    Column.text('updated_at'),
  ]),

  Table(areasTable, [
    Column.text('id'),
    Column.text('name'),
    Column.text('created_at'),
    Column.text('updated_at'),
  ]),

  Table(siteAreasTable, [
    Column.text('site_id'),
    Column.text('area_id'),
  ]),

  Table(unitsTable, [
    Column.text('id'),
    Column.text('site_id'),
    Column.text('name'),
    Column.text('created_at'),
    Column.text('updated_at'),
  ]),
  
  Table(levelsTable, [
    Column.text('id'),
    Column.text('unit_id'),
    Column.text('parent_id'),
    Column.text('name'),
    Column.integer('up_limit'),
    Column.integer('low_limit'),
    Column.text('created_at'),
    Column.text('updated_at'),
    Column.text('level_char'),
    Column.integer('level_int'),
  ]),
]);




