import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../budget/domain/budget_category_model.dart';
import '../../../goals/domain/goal_model.dart';
import '../../../recurring/domain/recurring_bill_model.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final transactions = ref.watch(transactionsProvider).valueOrNull ?? const [];
    final budgets = ref.watch(budgetCategoriesProvider).valueOrNull ?? const [];
    final recurringBills = ref.watch(recurringBillsProvider).valueOrNull ?? const [];
    final goals = ref.watch(goalsProvider).valueOrNull ?? const [];

    final totalIncome = transactions
        .where((entry) => entry.amountCents > 0)
        .fold<int>(0, (sum, entry) => sum + entry.amountCents);
    final totalSpent = transactions
        .where((entry) => entry.amountCents < 0)
        .fold<int>(0, (sum, entry) => sum + entry.amountCents.abs());

    final upcomingBills = [...recurringBills]
      ..sort((a, b) => a.nextDue.compareTo(b.nextDue));
    final upcomingBillTotal = upcomingBills
        .where((bill) => bill.nextDue.isBefore(DateTime.now().add(const Duration(days: 30))))
        .fold<int>(0, (sum, bill) => sum + bill.amountCents);

    final safeToSpend = totalIncome - totalSpent - upcomingBillTotal;
    final budgetSummary = budgets.where((budget) => budget.plannedCents > 0).toList();

    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good day, ${authState.userName?.split(' ').first ?? 'there'}!',
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              DateFormat('MMMM yyyy').format(DateTime.now()),
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notifications',
            onPressed: () => context.push(AppRoutes.notifications),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.wallet_outlined,
                        size: 16,
                        color: cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Safe to spend',
                        style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatCurrency(safeToSpend),
                    style: tt.displayLarge?.copyWith(
                      fontSize: 40,
                      color: cs.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatCurrency(totalIncome)} income • ${_formatCurrency(totalSpent)} spent',
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _QuickStat(
                  label: 'Income',
                  value: _formatCurrency(totalIncome),
                  icon: Icons.arrow_downward,
                  positive: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickStat(
                  label: 'Spent',
                  value: _formatCurrency(totalSpent),
                  icon: Icons.arrow_upward,
                  positive: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _SectionHeader(title: 'Budget', onSeeAll: () {}),
          const SizedBox(height: 8),
          if (budgetSummary.isEmpty)
            const _EmptyCard(
              icon: Icons.pie_chart_outline,
              message: 'No budget set for this month.\nTap Budget to get started.',
            )
          else
            ...budgetSummary.take(2).map(
              (budget) => _BudgetProgressTile(
                budget: budget,
              ),
            ),
          const SizedBox(height: 16),

          _SectionHeader(title: 'Upcoming bills', onSeeAll: () {}),
          const SizedBox(height: 8),
          if (upcomingBills.isEmpty)
            const _EmptyCard(
              icon: Icons.receipt_long_outlined,
              message: 'No upcoming bills tracked yet.',
            )
          else
            ...upcomingBills.take(2).map(
              (bill) => _UpcomingBillTile(bill: bill),
            ),
          const SizedBox(height: 16),

          _SectionHeader(title: 'Goals', onSeeAll: () {}),
          const SizedBox(height: 8),
          if (goals.isEmpty)
            const _EmptyCard(
              icon: Icons.flag_outlined,
              message: 'Set a savings goal to track your progress.',
            )
          else
            ...goals.take(2).map((goal) => _GoalTile(goal: goal)),
        ],
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
}

class _QuickStat extends StatelessWidget {
  const _QuickStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.positive,
  });
  final String label;
  final String value;
  final IconData icon;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final color = positive ? cs.income : cs.expense;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: tt.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onSeeAll});
  final String title;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        TextButton(onPressed: onSeeAll, child: const Text('See all')),
      ],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.icon, required this.message});
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
        child: Column(
          children: [
            Icon(
              icon,
              size: 36,
              color: cs.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetProgressTile extends StatelessWidget {
  const _BudgetProgressTile({required this.budget});

  final BudgetCategoryModel budget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = budget.plannedCents <= 0 ? 0.0 : (budget.spentCents / budget.plannedCents).clamp(0.0, 1.0);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(budget.name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                Text('${(progress * 100).round()}%'),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(budget.accentColor),
            ),
            const SizedBox(height: 8),
            Text(
              '${_formatCurrency(budget.spentCents)} / ${_formatCurrency(budget.plannedCents)}',
              style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
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
}

class _UpcomingBillTile extends StatelessWidget {
  const _UpcomingBillTile({required this.bill});

  final RecurringBillModel bill;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: bill.accentColor.withValues(alpha: 0.12),
          child: Icon(Icons.receipt_long_outlined, color: bill.accentColor),
        ),
        title: Text(
          bill.name,
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '${DateFormat.MMMd().format(bill.nextDue)} • ${bill.frequency}',
        ),
        trailing: Text(
          _formatCurrency(bill.amountCents),
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
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
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({required this.goal});

  final GoalModel goal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = goal.targetCents <= 0 ? 0.0 : (goal.currentCents / goal.targetCents).clamp(0.0, 1.0);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(goal.name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                Text('${(progress * 100).round()}%'),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(goal.accentColor),
            ),
            const SizedBox(height: 8),
            Text(
              '${_formatCurrency(goal.currentCents)} / ${_formatCurrency(goal.targetCents)}',
              style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
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
}

extension _AppColorsX on ColorScheme {
  Color get income => const Color(0xFF1A6B4A);
  Color get expense => const Color(0xFFB53A2F);
}
