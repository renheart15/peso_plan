import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';

class AddRecurringBillScreen extends ConsumerStatefulWidget {
  const AddRecurringBillScreen({super.key});

  @override
  ConsumerState<AddRecurringBillScreen> createState() =>
      _AddRecurringBillScreenState();
}

class _AddRecurringBillScreenState extends ConsumerState<AddRecurringBillScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Internet');
  final _amountController = TextEditingController(text: '1299');
  final _categoryController = TextEditingController(text: 'Utilities');
  late DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  String _frequency = 'monthly';
  bool _autoPay = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
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

  Future<void> _saveBill() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null) {
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
      final repo = ref.read(recurringBillRepositoryProvider);
      final payload = {
        'name': _nameController.text.trim(),
        'category_name': _categoryController.text.trim(),
        'amount_cents': (amount * 100).round(),
        'frequency': _frequency,
        'auto_pay': _autoPay,
        'next_due': _selectedDate.toIso8601String(),
      };

      final created = await repo.createRecurringBill(
        householdId: householdId,
        data: payload,
      );

      if (created != null) {
        if (!mounted) return;
        messenger?.showSnackBar(
          const SnackBar(content: Text('Recurring bill saved.')),
        );
        ref.invalidate(recurringBillsProvider);
        navigator.maybePop();
        return;
      }

      if (!mounted) return;
      await ref.read(offlineQueueServiceProvider).enqueue(
        method: 'POST',
        path: '/households/${householdId ?? 1}/recurring-bills',
        body: jsonEncode(payload),
      );
      messenger?.showSnackBar(
        const SnackBar(content: Text('Recurring bill queued for sync.')),
      );
      ref.invalidate(recurringBillsProvider);
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

    return Scaffold(
      appBar: AppBar(title: const Text('Add recurring bill')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Bill name',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Bill name is required'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _frequency,
              decoration: const InputDecoration(
                labelText: 'Frequency',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                DropdownMenuItem(value: 'quarterly', child: Text('Quarterly')),
                DropdownMenuItem(value: 'yearly', child: Text('Yearly')),
              ],
              onChanged: (value) => setState(() => _frequency = value ?? _frequency),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Next due date',
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
            SwitchListTile.adaptive(
              value: _autoPay,
              title: const Text('Auto-pay enabled'),
              onChanged: (value) => setState(() => _autoPay = value),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _isSaving ? null : _saveBill,
              icon: const Icon(Icons.check),
              label: _isSaving
                  ? const Text('Saving...')
                  : const Text('Save recurring bill'),
            ),
          ],
        ),
      ),
    );
  }
}
