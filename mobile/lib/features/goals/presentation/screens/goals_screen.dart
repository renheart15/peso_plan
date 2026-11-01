import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/goal_model.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final goalsAsync = ref.watch(goalsProvider);

    return goalsAsync.when(
      data: (goals) {
        final totalSaved = goals.fold<int>(
          0,
          (sum, goal) => sum + goal.currentCents,
        );
        final totalTarget = goals.fold<int>(
          0,
          (sum, goal) => sum + goal.targetCents,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Goals'),
            actions: [
              IconButton(
                onPressed: () => context.push(AppRoutes.debtPayoff),
                icon: const Icon(Icons.calculate_outlined),
                tooltip: 'Debt payoff planner',
              ),
              IconButton(
                onPressed: () => context.push(AppRoutes.addGoal),
                icon: const Icon(Icons.add_circle_outline),
                tooltip: 'Add goal',
              ),
            ],
          ),
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
                          Icon(
                            Icons.flag_rounded,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Goal progress',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _formatCurrency(totalSaved),
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Saved out of ${_formatCurrency(totalTarget)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 14),
                      LinearProgressIndicator(
                        value: totalTarget == 0 ? 0 : totalSaved / totalTarget,
                        minHeight: 12,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Current goals',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...goals.map((goal) => _GoalCard(goal: goal)),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.push(AppRoutes.addGoal),
            icon: const Icon(Icons.add),
            label: const Text('New goal'),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Scaffold(
        body: Center(child: Text('Unable to load goals right now.')),
      ),
    );
  }

  static String _formatCurrency(int value) {
    final formatter = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 0,
    );

    return formatter.format(value);
  }

  static void _showGoalDetails(BuildContext context, GoalModel goal) {
    final progress = goal.targetCents == 0
        ? 0.0
        : (goal.currentCents / goal.targetCents).clamp(0.0, 1.0);
    final remaining = goal.targetCents - goal.currentCents;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(goal.icon, color: goal.accentColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        goal.name,
                        style: Theme.of(sheetContext).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  goal.isDebtGoal ? 'Debt payoff goal' : 'Savings goal',
                  style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(sheetContext).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${GoalsScreen._formatCurrency(goal.currentCents)} saved of ${GoalsScreen._formatCurrency(goal.targetCents)}',
                  style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Theme.of(sheetContext)
                      .colorScheme
                      .surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(goal.accentColor),
                ),
                const SizedBox(height: 12),
                Text(
                  remaining >= 0
                      ? 'Remaining: ${GoalsScreen._formatCurrency(remaining)}'
                      : 'Over target: ${GoalsScreen._formatCurrency(remaining.abs())}',
                  style: Theme.of(sheetContext).textTheme.bodyMedium,
                ),
                if (goal.dueDate != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Due: ${DateFormat('MMM yyyy').format(goal.dueDate!)}',
                    style: Theme.of(sheetContext).textTheme.bodyMedium,
                  ),
                ],
                if (goal.notes != null && goal.notes!.trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    goal.notes!,
                    style: Theme.of(sheetContext).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.goal});

  final GoalModel goal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = goal.targetCents == 0
        ? 0.0
        : (goal.currentCents / goal.targetCents).clamp(0.0, 1.0);
    final remaining = goal.targetCents - goal.currentCents;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: goal.accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    goal.icon,
                    color: goal.accentColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${goal.isDebtGoal ? 'Debt payoff' : 'Savings goal'} • ${goal.dueDate == null ? 'No due date' : 'Due ${DateFormat('MMM yyyy').format(goal.dueDate!)}'}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: goal.accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${GoalsScreen._formatCurrency(goal.currentCents)} saved of ${GoalsScreen._formatCurrency(goal.targetCents)}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(goal.accentColor),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  remaining >= 0
                      ? 'Remaining: ${GoalsScreen._formatCurrency(remaining)}'
                      : 'Over target: ${GoalsScreen._formatCurrency(remaining.abs())}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                TextButton(
                  onPressed: () => GoalsScreen._showGoalDetails(context, goal),
                  child: const Text('Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
