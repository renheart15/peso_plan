import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';

/// Bottom navigation shell wrapping all main screens.
class MainScaffold extends ConsumerWidget {
  const MainScaffold({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    (label: 'Home', icon: Icons.home_outlined, route: AppRoutes.dashboard),
    (label: 'Budget', icon: Icons.pie_chart_outline, route: AppRoutes.budget),
    (label: 'Add', icon: Icons.add_circle, route: AppRoutes.addTransaction),
    (label: 'Reports', icon: Icons.bar_chart, route: AppRoutes.reports),
    (label: 'Settings', icon: Icons.settings_outlined, route: AppRoutes.settings),
  ];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(AppRoutes.dashboard)) return 0;
    if (location.startsWith(AppRoutes.budget)) return 1;
    if (location.startsWith(AppRoutes.transactions)) return 2;
    if (location.startsWith(AppRoutes.reports)) return 3;
    if (location.startsWith(AppRoutes.settings)) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIdx = _selectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIdx,
        onDestinationSelected: (i) {
          if (i == 2) {
            // Centre FAB → add transaction modal
            context.push(AppRoutes.addTransaction);
          } else {
            context.go(_tabs[i].route);
          }
        },
        destinations: _tabs
            .asMap()
            .entries
            .map(
              (e) => NavigationDestination(
                icon: e.key == 2
                    ? Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 28),
                      )
                    : Icon(e.value.icon),
                label: e.value.label,
                selectedIcon: e.key == 2
                    ? Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 28),
                      )
                    : Icon(e.value.icon, color: Theme.of(context).colorScheme.primary),
              ),
            )
            .toList(),
      ),
    );
  }
}
