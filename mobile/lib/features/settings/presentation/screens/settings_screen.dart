import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../core/router/app_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Profile tile
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  backgroundColor: cs.primaryContainer,
                  child: Text(
                    authState.userName?.substring(0, 1).toUpperCase() ?? 'U',
                    style: TextStyle(
                      color: cs.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                title: Text(
                  authState.userName ?? '',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  authState.userEmail ?? '',
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
            ),
          ),

          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.currency_exchange,
            title: 'Currency',
            subtitle: 'PHP — Philippine Peso',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('PHP is the active default currency.'),
              ),
            ),
          ),
          _SettingsTile(
            icon: Icons.language,
            title: 'Language & locale',
            subtitle: 'English (Philippines)',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('English (Philippines) is active.')),
            ),
          ),
          _SettingsTile(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Budget mode',
            subtitle: ref.watch(budgetModeProvider) == 'zero_based'
                ? 'Zero-based'
                : 'Simple',
            onTap: () {
              final mode = ref.read(budgetModeProvider);
              ref.read(budgetModeProvider.notifier).state = mode == 'simple'
                  ? 'zero_based'
                  : 'simple';
            },
          ),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () => context.push(AppRoutes.notifications),
          ),
          _SettingsTile(
            icon: Icons.dark_mode_outlined,
            title: 'Appearance',
            subtitle: 'System default',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Appearance is following the system theme.'),
              ),
            ),
          ),
          _SettingsTile(
            icon: Icons.group_outlined,
            title: 'Household',
            onTap: () => context.push(AppRoutes.household),
          ),
          _SettingsTile(
            icon: Icons.download_outlined,
            title: 'Export data',
            onTap: () => context.push(AppRoutes.exportData),
          ),
          _SettingsTile(
            icon: Icons.sync_outlined,
            title: 'Sync queue',
            subtitle: '3 pending items',
            onTap: () => context.push(AppRoutes.syncQueue),
          ),
          _SettingsTile(
            icon: Icons.accessibility_new_outlined,
            title: 'Accessibility',
            subtitle: 'Large text, contrast, motion',
            onTap: () => context.push(AppRoutes.accessibility),
          ),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'App info & release prep',
            subtitle: 'Version, build, launch checklist',
            onTap: () => context.push(AppRoutes.appInfo),
          ),
          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.logout,
            title: 'Sign out',
            textColor: cs.error,
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Sign out?'),
                  content: const Text(
                    'You will be returned to the login screen.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Sign out'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await ref.read(authStateProvider.notifier).logout();
              }
            },
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Peso Plan 0.1.0',
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.textColor,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: textColor ?? cs.onSurfaceVariant),
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
