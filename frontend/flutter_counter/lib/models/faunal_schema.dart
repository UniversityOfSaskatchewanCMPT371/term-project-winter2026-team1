import 'package:powersync/powersync.dart';

// Local PowerSync schema for faunal_data
const faunalSchema = Schema([
  Table('faunal_data', [
    Column.text('site'),
    Column.text('unit'),
    Column.integer('year_of_analysis'),
    Column.text('bone'),
    Column.text('description')
  ])
]);


