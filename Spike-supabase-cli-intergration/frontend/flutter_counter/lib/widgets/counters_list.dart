import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:powersync/powersync.dart';

import '../models/counter.dart';
import 'counter_card.dart';

/// Widget that displays a live-updating list of counters
class CountersList extends StatelessWidget {
  const CountersList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Counter>>(
      stream: context.watchCounters(),
      builder: (context, snapshot) {
        // Show loading indicator while data loads
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final counters = snapshot.data!;

        // Show helpful message when no counters exist
        if (counters.isEmpty) {
          return const Center(
            child: Text(
              'No counters yet!\nTap the + button to add one.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          );
        }

        // Build the list of counter cards
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: counters.length,
          itemBuilder: (context, index) {
            final counter = counters[index];
            final db = context.read<PowerSyncDatabase>();

            return Dismissible(
              key: ValueKey(counter.id),
              direction: DismissDirection.endToStart,
              // Red background when swiping to delete
              background: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: const Icon(Icons.delete, color: Colors.white, size: 32),
              ),
              onDismissed: (direction) async {
                final messenger = ScaffoldMessenger.of(context);
                await counter.delete(db);
                messenger.showSnackBar(
                  const SnackBar(content: Text('Counter deleted')),
                );
              },
              child: CounterCard(counter: counter),
            );
          },
        );
      },
    );
  }
}
