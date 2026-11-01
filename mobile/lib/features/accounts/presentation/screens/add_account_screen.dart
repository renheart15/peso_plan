import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';

class AddAccountScreen extends ConsumerStatefulWidget {
  const AddAccountScreen({super.key});

  @override
  ConsumerState<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends ConsumerState<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Savings');
  final _balanceController = TextEditingController(text: '5000');
  String _type = 'savings';
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _saveAccount() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final balance = double.tryParse(_balanceController.text.trim());
    if (balance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid balance.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final messenger = ScaffoldMessenger.maybeOf(context);
      final navigator = Navigator.of(context);
      final householdId = ref.read(authStateProvider).householdId;
      final repo = ref.read(accountRepositoryProvider);
      final payload = {
        'name': _nameController.text.trim(),
        'type': _type,
        'balance_cents': (balance * 100).round(),
        'balance': (balance * 100).round(),
      };

      final created = await repo.createAccount(
        householdId: householdId,
        data: payload,
      );

      if (created != null) {
        if (!mounted) return;
        messenger?.showSnackBar(
          const SnackBar(content: Text('Account saved.')),
        );
        ref.invalidate(accountsProvider);
        navigator.maybePop();
        return;
      }

      if (!mounted) return;
      await ref.read(offlineQueueServiceProvider).enqueue(
        method: 'POST',
        path: '/households/${householdId ?? 1}/accounts',
        body: jsonEncode(payload),
      );
      messenger?.showSnackBar(
        const SnackBar(content: Text('Account queued for sync.')),
      );
      ref.invalidate(accountsProvider);
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
      appBar: AppBar(title: const Text('Add account')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Account name',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Account name is required'
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(
                labelText: 'Account type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'checking', child: Text('Checking')),
                DropdownMenuItem(value: 'savings', child: Text('Savings')),
                DropdownMenuItem(value: 'cash', child: Text('Cash')),
                DropdownMenuItem(
                  value: 'credit_card',
                  child: Text('Credit card'),
                ),
              ],
              onChanged: (value) => setState(() => _type = value ?? _type),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _balanceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Current balance',
                prefixText: '₱ ',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Balance is required'
                  : null,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _isSaving ? null : _saveAccount,
              icon: const Icon(Icons.check),
              label: _isSaving
                  ? const Text('Saving...')
                  : const Text('Save account'),
            ),
          ],
        ),
      ),
    );
  }
}
