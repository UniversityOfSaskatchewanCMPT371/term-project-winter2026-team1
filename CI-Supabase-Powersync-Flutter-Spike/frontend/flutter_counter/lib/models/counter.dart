import 'package:flutter/widgets.dart';
import 'package:flutter_supabase_template/models/schema.dart';
import 'package:powersync/powersync.dart';
import 'package:powersync/sqlite3_common.dart' as sqlite;
import 'package:provider/provider.dart';

import '../powersync.dart';

/// Counter represents a result row of a query on "counters".
///
/// This class is immutable; methods on this class do not modify the instance
/// directly. Instead, watch or re-query the data to get the updated counter.
class Counter {
  /// Counter id (UUID).
  final String id;

  /// The counter's current value.
  final int count;

  /// The ID of the user who owns this counter.
  final String? ownerId;

  /// The creation timestamp.
  final String? createdAt;

  Counter({
    required this.id,
    required this.count,
    this.ownerId,
    this.createdAt,
  });

  factory Counter.fromRow(sqlite.Row row) {
    return Counter(
      id: row['id'],
      count: row['count'],
      ownerId: row['owner_id'],
      createdAt: row['created_at'],
    );
  }

  /// Increment the counter's value by one.
  Future<void> increment(PowerSyncDatabase db) async {
    await db.execute('UPDATE $countersTable SET count = ? WHERE id = ?', [
      count + 1,
      id,
    ]);
  }

  /// Decrement the counter's value by one. No-op at zero.
  Future<void> decrement(PowerSyncDatabase db) async {
    if (count <= 0) return;
    await db.execute('UPDATE $countersTable SET count = ? WHERE id = ?', [
      count - 1,
      id,
    ]);
  }

  /// Delete this counter.
  Future<void> delete(PowerSyncDatabase db) async {
    await db.execute('DELETE FROM $countersTable WHERE id = ?', [id]);
  }
}

/// Extension methods on BuildContext for Counter operations
extension CounterContext on BuildContext {
  /// Get the PowerSyncDatabase instance
  PowerSyncDatabase get database => watch<PowerSyncDatabase>();

  /// Watch all counters.
  Stream<List<Counter>> watchCounters() {
    final db = read<PowerSyncDatabase>();
    return db.watch('SELECT * FROM $countersTable ORDER BY created_at, id').map(
      (results) {
        return results.map(Counter.fromRow).toList(growable: false);
      },
    );
  }

  /// Create a new counter.
  Future<Counter> createCounter() async {
    final db = read<PowerSyncDatabase>();
    final results = await db.execute(
      '''
      INSERT INTO
        $countersTable(id, count, owner_id, created_at)
        VALUES(uuid(), ?, ?, datetime())
      RETURNING *
      ''',
      [0, getUserId()],
    );
    return Counter.fromRow(results.first);
  }
}
