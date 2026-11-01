import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/transaction_model.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  List<List<dynamic>> _csvPreview = const [];
  String? _csvFileName;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  bool _showSearch = false;
  bool _isImporting = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TransactionModel> _filteredTransactions(List<TransactionModel> transactions) {
    final query = _searchController.text.trim().toLowerCase();

    return transactions.where((entry) {
      final matchesFilter = switch (_selectedFilter) {
        'Income' => entry.isIncome,
        'Expense' => !entry.isIncome && entry.type.toLowerCase() != 'transfer',
        'Transfer' => entry.type.toLowerCase() == 'transfer',
        _ => true,
      };

      if (!matchesFilter) return false;
      if (query.isEmpty) return true;

      final haystack = [
        entry.title,
        entry.category,
        entry.accountName,
        entry.type,
        entry.notes ?? '',
      ].join(' ').toLowerCase();

      return haystack.contains(query);
    }).toList();
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final filters = ['All', 'Income', 'Expense', 'Transfer'];
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter transactions',
                  style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ...filters.map(
                  (filter) => ListTile(
                    title: Text(filter),
                    trailing: _selectedFilter == filter
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () {
                      setState(() => _selectedFilter = filter);
                      Navigator.of(sheetContext).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _importCsv() async {
    final pickerResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: false,
    );

    if (pickerResult == null || pickerResult.files.isEmpty) {
      return;
    }

    final file = pickerResult.files.first;
    final path = file.path;
    if (path == null) {
      return;
    }

    final csvText = await File(path).readAsString();
    final rows = const CsvToListConverter().convert(csvText);

    if (!mounted) {
      return;
    }

    setState(() {
      _csvFileName = file.name;
      _csvPreview = rows.take(5).toList();
      _isImporting = true;
    });

    final householdId = ref.read(authStateProvider).householdId;
    if (householdId == null || householdId <= 0) {
      setState(() => _isImporting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CSV preview loaded. Sign in to import to the API.')),
      );
      return;
    }

    final accounts = await ref.read(accountsProvider.future);
    if (!mounted) return;
    if (accounts.isEmpty) {
      setState(() => _isImporting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Create an account before importing CSV transactions.')),
      );
      return;
    }

    final importResult = await ref.read(transactionRepositoryProvider).importCsv(
      householdId: householdId,
      accountId: accounts.first.id,
      filePath: path,
      fileName: file.name,
    );

    if (!mounted) return;
    setState(() => _isImporting = false);
    ref.invalidate(transactionsProvider);

    final imported = importResult?['imported'] ?? 0;
    final skipped = importResult?['skipped'] ?? 0;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(importResult == null
            ? 'Unable to import CSV. Check the file format and try again.'
            : 'Imported $imported transactions; skipped $skipped duplicates.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final transactionsAsync = ref.watch(transactionsProvider);

    return transactionsAsync.when(
      data: (transactions) {
        final filteredTransactions = _filteredTransactions(transactions);
        final totalIncome = filteredTransactions
            .where((entry) => entry.amountCents > 0)
            .fold<int>(0, (sum, entry) => sum + entry.amountCents);
        final totalSpent = filteredTransactions
            .where((entry) => entry.amountCents < 0)
            .fold<int>(0, (sum, entry) => sum + entry.amountCents.abs());

        return Scaffold(
          appBar: AppBar(
            title: const Text('Transactions'),
            actions: [
              IconButton(
                onPressed: _isImporting ? null : _importCsv,
                icon: const Icon(Icons.upload_file_outlined),
                tooltip: 'Import CSV',
              ),
              IconButton(
                onPressed: () => context.push(AppRoutes.autoCategorization),
                icon: const Icon(Icons.auto_fix_high_outlined),
                tooltip: 'Auto-categorise',
              ),
              IconButton(
                onPressed: () => _openFilterSheet(context),
                icon: const Icon(Icons.filter_list_outlined),
                tooltip: 'Filter transactions',
              ),
              IconButton(
                onPressed: () {
                  setState(() => _showSearch = !_showSearch);
                  if (!_showSearch) {
                    _searchController.clear();
                  }
                },
                icon: const Icon(Icons.search_outlined),
                tooltip: 'Search transactions',
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_showSearch)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search title, category, account...',
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              icon: const Icon(Icons.clear),
                            )
                          : null,
                    ),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: 'Income',
                      value: _formatCurrency(totalIncome),
                      accent: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      label: 'Spent',
                      value: _formatCurrency(totalSpent),
                      accent: theme.colorScheme.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SegmentedButton<String>(
                selected: {_selectedFilter},
                segments: const [
                  ButtonSegment(value: 'All', label: Text('All')),
                  ButtonSegment(value: 'Income', label: Text('Income')),
                  ButtonSegment(value: 'Expense', label: Text('Expense')),
                  ButtonSegment(value: 'Transfer', label: Text('Transfer')),
                ],
                onSelectionChanged: (selection) {
                  if (selection.isNotEmpty) {
                    setState(() => _selectedFilter = selection.first);
                  }
                },
              ),
              const SizedBox(height: 16),
              if (_csvPreview.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'CSV preview',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (_csvFileName != null)
                              Text(
                                _csvFileName!,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ..._csvPreview.map(
                          (row) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              row.map((cell) => cell.toString()).join(' • '),
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_csvPreview.isNotEmpty) const SizedBox(height: 16),
              Text(
                'Recent activity',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              if (filteredTransactions.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'No transactions match your current search or filter.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                )
              else
                ...filteredTransactions.map(
                  (entry) => _TransactionTile(entry: entry),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.push(AppRoutes.addTransaction),
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Scaffold(
        body: Center(child: Text('Unable to load transactions right now.')),
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
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

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.entry});

  final TransactionModel entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncome = entry.isIncome;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: isIncome
                ? theme.colorScheme.primary.withValues(alpha: 0.12)
                : theme.colorScheme.error.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            entry.icon,
            color: isIncome
                ? theme.colorScheme.primary
                : theme.colorScheme.error,
          ),
        ),
        title: Text(
          entry.title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${entry.category} • ${entry.accountName}'),
            Text(DateFormat('MMM dd').format(entry.date)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isIncome ? '+' : '-'}₱${entry.amountCents.abs()}',
              style: theme.textTheme.titleSmall?.copyWith(
                color: isIncome
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              entry.type,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
