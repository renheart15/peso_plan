import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/app_providers.dart';
import '../../domain/goal_model.dart';

class DebtPayoffScreen extends ConsumerStatefulWidget {
  const DebtPayoffScreen({super.key});

  static const List<_Debt> _sampleDebts = [
    _Debt(
      name: 'Credit card',
      balance: 42000,
      apr: 18.9,
      minimum: 1800,
      color: Color(0xFFB53A2F),
    ),
    _Debt(
      name: 'Car loan',
      balance: 68000,
      apr: 9.5,
      minimum: 2600,
      color: Color(0xFF0E7C86),
    ),
    _Debt(
      name: 'Student loan',
      balance: 95000,
      apr: 6.8,
      minimum: 3200,
      color: Color(0xFF3A86FF),
    ),
  ];

  static String formatCurrency(int value) {
    final formatter = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 0,
    );

    return formatter.format(value);
  }

  static String formatCurrencyForDisplay(int value) => formatCurrency(value);

  /// Public read-only view of the sample debts (for tests and external consumers).
  static List<DebtInfo> get sampleDebts => _sampleDebts
      .map((d) => DebtInfo(
            name: d.name,
            balance: d.balance,
            apr: d.apr,
            minimum: d.minimum,
          ))
      .toList();

  @override
  ConsumerState<DebtPayoffScreen> createState() => _DebtPayoffScreenState();
}

class _DebtPayoffScreenState extends ConsumerState<DebtPayoffScreen> {
  String _strategy = 'avalanche';
  late List<_Debt> _manualDebts = List.of(DebtPayoffScreen._sampleDebts);

  Future<void> _addDebt() async {
    final formKey = GlobalKey<FormState>();
    String name = 'New debt';
    String balanceText = '25000';
    String aprText = '12.5';
    String minimumText = '1200';

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add debt'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: name,
                  decoration: const InputDecoration(labelText: 'Debt name'),
                  onChanged: (value) => name = value.trim().isEmpty ? 'New debt' : value,
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: balanceText,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Balance'),
                  onChanged: (value) => balanceText = value,
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: aprText,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'APR %'),
                  onChanged: (value) => aprText = value,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: minimumText,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Minimum payment'),
                  onChanged: (value) => minimumText = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  Navigator.of(context).pop(true);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    final parsedBalance = double.tryParse(balanceText) ?? 25000;
    final parsedApr = double.tryParse(aprText) ?? 12.5;
    final parsedMinimum = double.tryParse(minimumText) ?? 1200;

    setState(() {
      _manualDebts = [
        ..._manualDebts,
        _Debt(
          name: name,
          balance: (parsedBalance * 100).round(),
          apr: parsedApr,
          minimum: (parsedMinimum * 100).round(),
          color: const Color(0xFF1A6B4A),
        ),
      ];
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added $name to the payoff plan.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goalsAsync = ref.watch(goalsProvider);

    return goalsAsync.when(
      data: (goals) {
        final debts = _buildDebts(goals, _manualDebts);
        final totalBalance = debts.fold<int>(
          0,
          (sum, debt) => sum + debt.balance,
        );
        final totalMinimum = debts.fold<int>(
          0,
          (sum, debt) => sum + debt.minimum,
        );
        final monthlyBoost = debts.isEmpty
            ? 15000
            : _recommendedBoost(totalBalance);
        final payoffMonths = debts.isEmpty
            ? 0
            : math.max(1, (totalBalance / math.max(monthlyBoost, 1)).round());
        final planRows = debts.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final debt = entry.value;
          final extra = debt.balance == 0
              ? 0
              : (debt.balance / math.max(debts.length, 1)).round();
          return _PlanRow(
            label: '$index. ${debt.name}',
            amount: '${DebtPayoffScreen.formatCurrency(extra)} extra',
          );
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Debt payoff planner'),
            actions: [
              IconButton(
                onPressed: _addDebt,
                icon: const Icon(Icons.add_circle_outline),
                tooltip: 'Add debt',
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
                      Text(
                        'Recommended strategy',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SegmentedButton<String>(
                        selected: {_strategy},
                        segments: const [
                          ButtonSegment(
                            value: 'snowball',
                            label: Text('Snowball'),
                          ),
                          ButtonSegment(
                            value: 'avalanche',
                            label: Text('Avalanche'),
                          ),
                        ],
                        onSelectionChanged: (value) {
                          setState(() => _strategy = value.first);
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'Total balance',
                              value: DebtPayoffScreen.formatCurrency(totalBalance),
                              accent: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              label: 'Monthly boost',
                              value: DebtPayoffScreen.formatCurrency(monthlyBoost),
                              accent: theme.colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'Payoff time',
                              value: '$payoffMonths months',
                              accent: theme.colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              label: 'Min payment',
                              value: DebtPayoffScreen.formatCurrency(totalMinimum),
                              accent: theme.colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Debt list',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...debts.map((debt) => _DebtCard(debt: debt)),
              const SizedBox(height: 18),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Suggested payoff sequence',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...planRows,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Debt payoff plan saved locally for this session.'),
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Save plan'),
              ),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Scaffold(
        body: Center(child: Text('Unable to load your debt plan right now.')),
      ),
    );
  }

  static List<_Debt> _buildDebts(List<GoalModel> goals, List<_Debt> manualDebts) {
    final debtGoals = goals.where((goal) => goal.isDebtGoal).toList();
    final debts = <_Debt>[];

    if (debtGoals.isNotEmpty) {
      debts.addAll(
        debtGoals.map((goal) {
          final remainingBalance = math.max(
            0,
            goal.targetCents - goal.currentCents,
          );
          final apr = goal.name.toLowerCase().contains('car')
              ? 9.5
              : goal.name.toLowerCase().contains('student')
                  ? 6.8
                  : 18.9;
          final minimum = remainingBalance == 0
              ? 0
              : math.max(1500, (remainingBalance * 0.05).round());

          return _Debt(
            name: goal.name,
            balance: remainingBalance,
            apr: apr,
            minimum: minimum,
            color: goal.accentColor,
          );
        }),
      );
    }

    if (manualDebts.isNotEmpty) {
      debts.addAll(manualDebts);
    }

    if (debts.isEmpty) {
      return DebtPayoffScreen._sampleDebts;
    }

    debts.sort((a, b) => b.balance.compareTo(a.balance));
    return debts;
  }

  static int _recommendedBoost(int totalBalance) {
    if (totalBalance <= 0) return 15000;
    return math.max(15000, (totalBalance * 0.18 / 3).round());
  }

}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DebtCard extends StatelessWidget {
  const _DebtCard({required this.debt});

  final _Debt debt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = debt.balance <= 0 ? 0.0 : 0.6;
    final monthlyExtra = debt.balance == 0 ? 0 : (debt.balance / 4).round();

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: debt.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.credit_card, color: debt.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        debt.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${debt.apr.toStringAsFixed(1)}% APR • Min ${DebtPayoffScreen.formatCurrencyForDisplay(debt.minimum)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  DebtPayoffScreen.formatCurrencyForDisplay(debt.balance),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: debt.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(debt.color),
            ),
            const SizedBox(height: 8),
            Text(
              'Projected payoff: ${debt.balance == 0 ? 'Paid off' : '5 months'} • add ${DebtPayoffScreen.formatCurrencyForDisplay(monthlyExtra)} / month',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  const _PlanRow({required this.label, required this.amount});

  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            amount,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Debt {
  const _Debt({
    required this.name,
    required this.balance,
    required this.apr,
    required this.minimum,
    required this.color,
  });

  final String name;
  final int balance;
  final double apr;
  final int minimum;
  final Color color;
}

/// Public read-only view of a debt entry, used by tests and external consumers.
class DebtInfo {
  const DebtInfo({
    required this.name,
    required this.balance,
    required this.apr,
    required this.minimum,
  });

  final String name;
  final int balance;
  final double apr;
  final int minimum;
}
