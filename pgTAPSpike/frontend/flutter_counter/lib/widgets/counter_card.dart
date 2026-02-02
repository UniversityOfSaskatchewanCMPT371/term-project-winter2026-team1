import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:powersync/powersync.dart' hide Column;

import '../models/counter.dart';

/// Individual counter card widget
class CounterCard extends StatelessWidget {
  const CounterCard({super.key, required this.counter});

  final Counter counter;

  @override
  Widget build(BuildContext context) {
    final db = context.read<PowerSyncDatabase>();

    // Truncate the ID to first 8 characters for display
    final displayId = counter.id.length > 8
        ? '${counter.id.substring(0, 8)}...'
        : counter.id;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Counter info on the left
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID: $displayId',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Count: ${counter.count}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  // Show creation date if available
                  if (counter.createdAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Created: ${_formatDate(counter.createdAt!)}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),
            // Counter controls on the right
            Row(
              children: [
                // Decrement button
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.red),
                  onPressed: () async {
                    await counter.decrement(db);
                  },
                ),
                // Current count display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${counter.count}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Increment button
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.green),
                  onPressed: () async {
                    await counter.increment(db);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Formats date string for display
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Unknown';
    }
  }
}
