import 'package:flutter/material.dart';

import '../../../../firebase_options.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final checklist = <_ChecklistItemData>[
      _ChecklistItemData(label: 'Authentication + permissions', complete: true),
      _ChecklistItemData(
        label: 'Budget, goals, and transactions flow',
        complete: true,
      ),
      _ChecklistItemData(label: 'Household sharing and alerts', complete: true),
      _ChecklistItemData(label: 'Offline queue replay flow', complete: true),
      _ChecklistItemData(
        label: 'Production Firebase configuration',
        complete: false,
      ),
      _ChecklistItemData(label: 'API integration pass', complete: false),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('App info & release prep')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Peso Plan',
                    style: tt.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 0.1.0 · dev build',
                    style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 18),
                  _InfoRow(label: 'Platform', value: 'Android + iOS'),
                  _InfoRow(label: 'Environment', value: 'local-dev'),
                  _InfoRow(
                    label: 'Firebase',
                    value: DefaultFirebaseOptions.isConfigured
                        ? 'Configured'
                        : 'Placeholder config (safe dev mode)',
                  ),
                  _InfoRow(label: 'API', value: 'http://10.0.2.2:8000/api/v1'),
                  _InfoRow(label: 'Locale', value: 'en_PH'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Release readiness',
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...checklist.map((item) => _ChecklistLine(item: item)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current status',
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Feature work is complete for the sample-data UI flow. Remaining launch work is real API wiring, production Firebase configuration, and final QA on device builds.',
                    style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistLine extends StatelessWidget {
  const _ChecklistLine({required this.item});

  final _ChecklistItemData item;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.complete
                ? Icons.check_circle_rounded
                : Icons.pending_actions_rounded,
            color: item.complete ? cs.primary : cs.tertiary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.label,
              style: tt.bodyMedium?.copyWith(
                color: item.complete ? cs.onSurface : cs.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistItemData {
  const _ChecklistItemData({required this.label, required this.complete});

  final String label;
  final bool complete;
}
