import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';

class AddGoalScreen extends ConsumerStatefulWidget {
  const AddGoalScreen({super.key, this.goalId});

  final int? goalId;

  @override
  ConsumerState<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends ConsumerState<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Emergency fund');
  final _targetController = TextEditingController(text: '150000');
  final _currentController = TextEditingController(text: '50000');
  final _notesController = TextEditingController();
  late DateTime _selectedDate = DateTime.now().add(const Duration(days: 180));
  String _type = 'savings';
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    _currentController.dispose();
    _notesController.dispose();
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

  Future<void> _saveGoal() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final target = double.tryParse(_targetController.text.trim());
    final current = double.tryParse(_currentController.text.trim());
    if (target == null || current == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid target and current amounts.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final messenger = ScaffoldMessenger.maybeOf(context);
      final navigator = Navigator.of(context);
      final householdId = ref.read(authStateProvider).householdId;
      final repo = ref.read(goalRepositoryProvider);
      final payload = {
        'name': _nameController.text.trim(),
        'type': _type,
        'target_cents': (target * 100).round(),
        'current_cents': (current * 100).round(),
        'due_date': _selectedDate.toIso8601String(),
        'notes': _notesController.text.trim(),
      };

      final created = await repo.createGoal(
        householdId: householdId,
        data: payload,
      );

      if (created != null) {
        if (!mounted) return;
        messenger?.showSnackBar(
          const SnackBar(content: Text('Goal saved.')),
        );
        ref.invalidate(goalsProvider);
        navigator.maybePop();
        return;
      }

      if (!mounted) return;
      await ref.read(offlineQueueServiceProvider).enqueue(
        method: 'POST',
        path: '/households/${householdId ?? 1}/goals',
        body: jsonEncode(payload),
      );
      messenger?.showSnackBar(
        const SnackBar(content: Text('Goal queued for sync.')),
      );
      ref.invalidate(goalsProvider);
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
    final title = widget.goalId == null ? 'Add goal' : 'Edit goal';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveGoal,
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
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(
                labelText: 'Goal type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'savings', child: Text('Savings goal')),
                DropdownMenuItem(value: 'debt', child: Text('Debt payoff')),
              ],
              onChanged: (value) => setState(() => _type = value ?? _type),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Goal name',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Goal name is required'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _targetController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Target amount',
                prefixText: '₱ ',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Target amount is required'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _currentController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Current saved',
                prefixText: '₱ ',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Current saved is required'
                  : null,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Target date',
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
            TextFormField(
              controller: _notesController,
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
              onPressed: _isSaving ? null : _saveGoal,
              icon: const Icon(Icons.check),
              label: _isSaving
                  ? const Text('Saving...')
                  : const Text('Save goal'),
            ),
          ],
        ),
      ),
    );
  }
}
