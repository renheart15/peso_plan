import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key, this.transactionId});

  final int? transactionId;

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController(text: '2500');
  final _descriptionController = TextEditingController(text: 'Grocery run');
  final _payeeController = TextEditingController(text: 'SM Hypermarket');
  late DateTime _selectedDate = DateTime.now();
  String _transactionType = 'expense';
  String _selectedAccount = 'Checking';
  String _selectedCategory = 'Groceries';
  bool _isSaving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _payeeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveTransaction() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final parsedAmount = double.tryParse(_amountController.text.trim());
    if (parsedAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final messenger = ScaffoldMessenger.maybeOf(context);
      final navigator = Navigator.of(context);
      final householdId = ref.read(authStateProvider).householdId;
      final repo = ref.read(transactionRepositoryProvider);
      final accounts = householdId == null
          ? const <dynamic>[]
          : await ref.read(accountsProvider.future);
      final selectedAccount = accounts.firstWhere(
        (account) => account.name == _selectedAccount,
        orElse: () => accounts.isNotEmpty ? accounts.first : null,
      );
      final payload = {
        'title': _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : 'Transaction',
        'payee': _payeeController.text.trim().isNotEmpty
            ? _payeeController.text.trim()
            : 'Expense',
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory,
        'account': _selectedAccount,
        'account_name': _selectedAccount,
        if (selectedAccount != null) 'account_id': selectedAccount.id,
        'type': _transactionType,
        'amount_cents': (parsedAmount * 100).round(),
        'date': _selectedDate.toIso8601String(),
        'notes': '',
      };

      final saved = await repo.createTransaction(
        householdId: householdId,
        data: payload,
      );

      if (saved != null) {
        if (!mounted) return;
        messenger?.showSnackBar(
          const SnackBar(content: Text('Transaction saved.')),
        );
        ref.invalidate(transactionsProvider);
        navigator.maybePop();
        return;
      }

      if (!mounted) return;
      await ref.read(offlineQueueServiceProvider).enqueue(
        method: 'POST',
        path: '/households/${householdId ?? 1}/transactions',
        body: jsonEncode(payload),
      );
      messenger?.showSnackBar(
        const SnackBar(content: Text('Transaction queued for sync.')),
      );
      ref.invalidate(transactionsProvider);
      navigator.maybePop();
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.transactionId == null
        ? 'Add transaction'
        : 'Edit transaction';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveTransaction,
            child: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SegmentedButton<String>(
              selected: {_transactionType},
              segments: const [
                ButtonSegment(value: 'income', label: Text('Income')),
                ButtonSegment(value: 'expense', label: Text('Expense')),
                ButtonSegment(value: 'transfer', label: Text('Transfer')),
              ],
              onSelectionChanged: (selection) {
                if (selection.isNotEmpty) {
                  setState(() => _transactionType = selection.first);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₱ ',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Amount is required'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _payeeController,
              decoration: const InputDecoration(
                labelText: 'Payee / source',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: const OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.calendar_today_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
                child: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedAccount,
              decoration: const InputDecoration(
                labelText: 'Account',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Checking', child: Text('Checking')),
                DropdownMenuItem(value: 'Savings', child: Text('Savings')),
                DropdownMenuItem(value: 'Cash', child: Text('Cash')),
              ],
              onChanged: (value) =>
                  setState(() => _selectedAccount = value ?? _selectedAccount),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Groceries', child: Text('Groceries')),
                DropdownMenuItem(value: 'Housing', child: Text('Housing')),
                DropdownMenuItem(value: 'Utilities', child: Text('Utilities')),
                DropdownMenuItem(value: 'Salary', child: Text('Salary')),
              ],
              onChanged: (value) => setState(
                () => _selectedCategory = value ?? _selectedCategory,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Notes',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _isSaving ? null : _saveTransaction,
              icon: const Icon(Icons.check),
              label: _isSaving
                  ? const Text('Saving...')
                  : const Text('Save transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
