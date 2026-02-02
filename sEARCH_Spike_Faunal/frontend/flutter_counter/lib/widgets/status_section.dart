import 'package:flutter/material.dart';
import 'package:powersync/powersync.dart' hide Column;
import 'package:provider/provider.dart';

import 'key_value.dart';

/// Displays PowerSync connection status
class StatusSection extends StatelessWidget {
  const StatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: _StatusSection(),
    );
  }
}

class _StatusSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final db = context.watch<PowerSyncDatabase>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<SyncStatus>(
          stream: db.statusStream,
          initialData: db.currentStatus,
          builder: (context, snapshot) {
            final status = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'PowerSync Status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (status != null) ...[
                  KeyValue(
                    keyLabel: 'connected',
                    value: status.connected.toString(),
                  ),
                  KeyValue(
                    keyLabel: 'connecting',
                    value: status.connecting.toString(),
                  ),
                  KeyValue(
                    keyLabel: 'uploading',
                    value: status.uploading.toString(),
                  ),
                  KeyValue(
                    keyLabel: 'downloading',
                    value: status.downloading.toString(),
                  ),
                  KeyValue(
                    keyLabel: 'downloadProgress',
                    value: status.downloadProgress?.downloadedFraction != null
                        ? '${(status.downloadProgress!.downloadedFraction * 100).toStringAsFixed(2)}%'
                        : '0%',
                  ),
                  KeyValue(
                    keyLabel: 'hasSynced',
                    value: (status.hasSynced ?? false).toString(),
                  ),
                  KeyValue(
                    keyLabel: 'lastSyncedAt',
                    value: status.lastSyncedAt?.toUtc().toString() ?? 'N/A',
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
