import 'package:powersync/powersync.dart';

const countersTable = 'counters';

const schema = Schema([
  Table(countersTable, [
    Column.integer('owner_id'), // String field for identifying record owner
    Column.integer('count'), // Number field for counter value
    Column.text('created_at'), // Timestamp field for record creation time
    Column.text('modified_at'),
  ]),
]);