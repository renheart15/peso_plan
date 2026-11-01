import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/budget_category_model.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(budgetModeProvider);
    final monthLabel = DateFormat.yMMMM().format(DateTime.now());
    final categoriesAsync = ref.watch(budgetCategoriesProvider);

    return categoriesAsync.when(
      data: (categories) {
        final totalPlanned = categories.fold<int>(
          0,
          (sum, item) => sum + item.plannedCents,
        );
        final totalSpent = categories.fold<int>(
          0,
          (sum, item) => sum + item.spentCents,
        );
        final remaining = totalPlanned - totalSpent;
        final progress = totalPlanned == 0 ? 0.0 : totalSpent / totalPlanned;

        return Scaffold(
          appBar: AppBar(
            title: Text(monthLabel),
            actions: [
              IconButton(
                tooltip: 'Add budget item',
                onPressed: () => context.push(AppRoutes.addBudget),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ModeCard(mode: mode),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Budget health',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              mode == AppConstants.budgetModeSimple
                                  ? 'Simple mode'
                                  : 'Zero-based',
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _BudgetMetric(
                              label: 'Income',
                              value: _formatCurrency(50000),
                              accent: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _BudgetMetric(
                              label: 'Remaining',
                              value: _formatCurrency(remaining),
                              accent: remaining >= 0
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        '${_formatCurrency(totalSpent)} spent of ${_formatCurrency(totalPlanned)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 12,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progress > 0.8
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${(progress * 100).round()}% allocated',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Adjust all is available from the category edit flow.',
                        ),
                      ),
                    ),
                    child: const Text('Adjust all'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...categories.map((item) => _BudgetCategoryTile(item: item)),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Scaffold(
        body: Center(
          child: Text('Unable to load budget categories right now.'),
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

class _ModeCard extends ConsumerWidget {
  const _ModeCard({required this.mode});

  final String mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Budget style',
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              selected: {mode},
              onSelectionChanged: (selection) {
                if (selection.isNotEmpty) {
                  ref.read(budgetModeProvider.notifier).state = selection.first;
                }
              },
              segments: const [
                ButtonSegment<String>(
                  value: AppConstants.budgetModeSimple,
                  label: Text('Simple'),
                  icon: Icon(Icons.tune_rounded),
                ),
                ButtonSegment<String>(
                  value: AppConstants.budgetModeZeroBased,
                  label: Text('Zero-based'),
                  icon: Icon(Icons.account_balance_wallet_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetMetric extends StatelessWidget {
  const _BudgetMetric({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetCategoryTile extends StatelessWidget {
  const _BudgetCategoryTile({required this.item});

  final BudgetCategoryModel item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spentRatio = item.plannedCents == 0
        ? 0.0
        : item.spentCents / item.plannedCents;
    final remaining = item.plannedCents - item.spentCents;

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
                    color: item.accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: item.accentColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${BudgetScreen._formatCurrency(item.spentCents)} spent of ${BudgetScreen._formatCurrency(item.plannedCents)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  BudgetScreen._formatCurrency(remaining),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: remaining >= 0
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: spentRatio.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  item.isOverBudget
                      ? theme.colorScheme.error
                      : item.accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
