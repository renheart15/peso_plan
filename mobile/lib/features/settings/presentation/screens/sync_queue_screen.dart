import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';

class SyncQueueScreen extends ConsumerWidget {
  const SyncQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final queueAsync = ref.watch(offlineQueueProvider);
    final isOnline = ref.watch(isOnlineProvider);

    return queueAsync.when(
      data: (queueRows) {
        final queueItems = queueRows.isEmpty
            ? [
                _QueueItem(
                  operation: 'No queued writes',
                  status: 'Idle',
                  time: 'Ready to sync',
                  accent: cs.primary,
                ),
              ]
            : queueRows.map((row) {
                final status = row.isFailed
                    ? 'Failed'
                    : (row.retryCount > 0 ? 'Retrying' : 'Queued');
                final createdAgo = DateTime.now().difference(row.createdAt).inMinutes;
                final timeAgo = createdAgo <= 0
                    ? 'just now'
                    : '$createdAgo min ago';

                return _QueueItem(
                  operation: '${row.method} ${row.path}',
                  status: status,
                  time: timeAgo,
                  accent: row.isFailed
                      ? cs.error
                      : row.retryCount > 0
                          ? cs.primary
                          : cs.tertiary,
                );
              }).toList();

        final queuedCount = queueRows.length;
        final retryingCount = queueRows.where((row) => row.retryCount > 0 && !row.isFailed).length;
        final failedCount = queueRows.where((row) => row.isFailed).length;

        return Scaffold(
          appBar: AppBar(title: const Text('Sync queue')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.sync, color: cs.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Offline sync status',
                            style: tt.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        !isOnline
                            ? 'Offline — queued writes will sync automatically when connected.'
                            : queueRows.isEmpty
                                ? 'No queued writes in the local cache right now.'
                                : '$queuedCount queued write(s) are waiting to sync.',
                        style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _MetricCard(
                              label: 'Queued',
                              value: '$queuedCount',
                              accent: cs.tertiary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MetricCard(
                              label: 'Retrying',
                              value: '$retryingCount',
                              accent: cs.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MetricCard(
                              label: 'Failed',
                              value: '$failedCount',
                              accent: cs.error,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Text(
                    'Queue items',
                    style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  FilledButton.tonalIcon(
                    onPressed: !isOnline
                        ? null
                        : () async {
                            final service = ref.read(offlineQueueServiceProvider);
                            final syncedCount = await service.syncAll();
                            ref.invalidate(offlineQueueProvider);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(syncedCount == 0
                                    ? 'No queued writes were synchronized.'
                                    : 'Synchronized $syncedCount queued write(s).' ),
                              ),
                            );
                          },
                    icon: const Icon(Icons.sync_outlined),
                    label: const Text('Sync now'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...queueItems.map((item) => _QueueTile(item: item)),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const Scaffold(
        body: Center(child: Text('Unable to load the sync queue right now.')),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: tt.labelMedium),
          const SizedBox(height: 6),
          Text(
            value,
            style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _QueueTile extends StatelessWidget {
  const _QueueTile({required this.item});

  final _QueueItem item;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        leading: CircleAvatar(
          backgroundColor: item.accent.withValues(alpha: 0.12),
          child: Icon(Icons.cloud_sync_outlined, color: item.accent),
        ),
        title: Text(
          item.operation,
          style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: item.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item.status,
                  style: tt.labelSmall?.copyWith(
                    color: item.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                item.time,
                style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QueueItem {
  const _QueueItem({
    required this.operation,
    required this.status,
    required this.time,
    required this.accent,
  });

  final String operation;
  final String status;
  final String time;
  final Color accent;
}
