import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  bool _pushEnabled = false;
  bool _isRequesting = false;
  bool _budgetAlertsEnabled = true;
  bool _recurringRemindersEnabled = true;
  bool _householdActivityEnabled = false;

  final List<_NotificationItemData> _alerts = [
    _NotificationItemData(
      title: 'Budget alert',
      description: 'You are ₱1,250 under your food budget with 3 days left in the month.',
      time: 'Today · 8:20 AM',
      icon: Icons.wallet_outlined,
      accent: Colors.teal,
      unread: true,
    ),
    _NotificationItemData(
      title: 'Recurring bill due soon',
      description: 'Internet bill is due tomorrow. Your autopay is set to trigger at 9:00 AM.',
      time: 'Today · 7:15 AM',
      icon: Icons.receipt_long_outlined,
      accent: Colors.orange,
      unread: true,
    ),
    _NotificationItemData(
      title: 'Household update',
      description: 'Maria added a new grocery account and synced the latest transactions.',
      time: 'Yesterday',
      icon: Icons.group_outlined,
      accent: Colors.blue,
      unread: false,
    ),
    _NotificationItemData(
      title: 'Smart insight',
      description: 'Your spending is 12% lower than last month in groceries and utilities.',
      time: 'Yesterday',
      icon: Icons.insights_outlined,
      accent: Colors.green,
      unread: false,
    ),
  ];

  void _markAllRead() {
    setState(() {
      for (final alert in _alerts) {
        alert.unread = false;
      }
    });
  }

  Future<void> _togglePushNotifications() async {
    if (_isRequesting) {
      return;
    }

    setState(() => _isRequesting = true);

    try {
      final service = ref.read(notificationServiceProvider);
      final granted = await service.requestPermission();

      if (!mounted) {
        return;
      }

      setState(() => _pushEnabled = granted);

      if (granted) {
        final token = await service.getDeviceToken();
        if (mounted && token != null) {
          final preview = token.length > 12 ? token.substring(0, 12) : token;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Push notifications enabled. Token: $preview...'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Notifications were not enabled. You can try again later.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRequesting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery preferences',
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _PreferenceRow(
                    label: 'Push notifications',
                    value: _pushEnabled,
                    enabled: !_isRequesting,
                    onChanged: (_) => _togglePushNotifications(),
                  ),
                  const Divider(height: 1),
                  _PreferenceRow(
                    label: 'Budget alerts',
                    value: _budgetAlertsEnabled,
                    enabled: !_isRequesting,
                    onChanged: (value) =>
                        setState(() => _budgetAlertsEnabled = value),
                  ),
                  const Divider(height: 1),
                  _PreferenceRow(
                    label: 'Recurring bill reminders',
                    value: _recurringRemindersEnabled,
                    enabled: !_isRequesting,
                    onChanged: (value) =>
                        setState(() => _recurringRemindersEnabled = value),
                  ),
                  const Divider(height: 1),
                  _PreferenceRow(
                    label: 'Household activity',
                    value: _householdActivityEnabled,
                    enabled: !_isRequesting,
                    onChanged: (value) =>
                        setState(() => _householdActivityEnabled = value),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _pushEnabled
                        ? 'Push notifications are enabled for this device.'
                        : 'Push notifications are off. Enable them to receive budget alerts and household updates.',
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Recent activity',
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              TextButton(
                onPressed: _markAllRead,
                child: const Text('Mark all read'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._alerts.map((alert) => _NotificationTile(item: alert)),
        ],
      ),
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.enabled,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: tt.bodyMedium?.copyWith(color: cs.onSurface),
            ),
          ),
          Switch(value: value, onChanged: enabled ? onChanged : null),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item});

  final _NotificationItemData item;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: item.accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(item.icon, color: item.accent),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                item.title,
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            if (item.unread)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(item.description),
            const SizedBox(height: 6),
            Text(
              item.time,
              style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItemData {
  _NotificationItemData({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.accent,
    required this.unread,
  });

  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color accent;
  bool unread;
}
