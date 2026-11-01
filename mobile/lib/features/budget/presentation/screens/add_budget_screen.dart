import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';

class AddBudgetScreen extends ConsumerStatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  ConsumerState<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends ConsumerState<AddBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Groceries');
  final _plannedController = TextEditingController(text: '12000');
  final _spentController = TextEditingController(text: '8500');
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _plannedController.dispose();
    _spentController.dispose();
    super.dispose();
  }

  Future<void> _saveBudget() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final planned = double.tryParse(_plannedController.text.trim());
    final spent = double.tryParse(_spentController.text.trim());
    if (planned == null || spent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Use valid dollar/ peso amounts.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final messenger = ScaffoldMessenger.maybeOf(context);
      final navigator = Navigator.of(context);
      final householdId = ref.read(authStateProvider).householdId;
      final repo = ref.read(budgetRepositoryProvider);
      final payload = {
        'name': _nameController.text.trim(),
        'category_name': _nameController.text.trim(),
        'planned_cents': (planned * 100).round(),
        'spent_cents': (spent * 100).round(),
      };

      final created = await repo.createBudgetCategory(
        householdId: householdId,
        data: payload,
      );

      if (created != null) {
        if (!mounted) return;
        messenger?.showSnackBar(
          const SnackBar(content: Text('Budget item saved.')),
        );
        ref.invalidate(budgetCategoriesProvider);
        navigator.maybePop();
        return;
      }

      if (!mounted) return;
      await ref.read(offlineQueueServiceProvider).enqueue(
        method: 'POST',
        path: '/households/${householdId ?? 1}/budgets',
        body: jsonEncode(payload),
      );
      messenger?.showSnackBar(
        const SnackBar(content: Text('Budget item queued for sync.')),
      );
      ref.invalidate(budgetCategoriesProvider);
      navigator.maybePop();
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add budget item')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category name',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Category name is required'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _plannedController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Planned amount',
                prefixText: '₱ ',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Planned amount is required'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _spentController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Spent amount',
                prefixText: '₱ ',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Spent amount is required'
                  : null,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _isSaving ? null : _saveBudget,
              icon: const Icon(Icons.check),
              label: _isSaving
                  ? const Text('Saving...')
                  : const Text('Save budget item'),
            ),
          ],
        ),
      ),
    );
  }
}
