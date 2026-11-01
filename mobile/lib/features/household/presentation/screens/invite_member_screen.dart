import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';

class InviteMemberScreen extends ConsumerStatefulWidget {
  const InviteMemberScreen({super.key});

  @override
  ConsumerState<InviteMemberScreen> createState() => _InviteMemberScreenState();
}

class _InviteMemberScreenState extends ConsumerState<InviteMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String _role = 'member';
  bool _isSaving = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _inviteMember() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final messenger = ScaffoldMessenger.maybeOf(context);
      final navigator = Navigator.of(context);
      final householdId = ref.read(authStateProvider).householdId;
      final repo = ref.read(householdRepositoryProvider);

      final email = _emailController.text.trim();
      final result = await repo.inviteMember(
        householdId: householdId,
        email: email,
        role: _role,
      );

      if (!mounted) return;

      if (result) {
        messenger?.showSnackBar(
          const SnackBar(content: Text('Invitation sent.')),
        );
        ref.invalidate(householdSummaryProvider);
        navigator.maybePop();
        return;
      }

      messenger?.showSnackBar(
        const SnackBar(content: Text('Unable to send invitation right now.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invite member')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return 'Email is required';
                final hasAt = text.contains('@') && text.contains('.');
                return hasAt ? null : 'Enter a valid email';
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _role,
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'member', child: Text('Member')),
                DropdownMenuItem(value: 'manager', child: Text('Manager')),
                DropdownMenuItem(value: 'owner', child: Text('Owner')),
              ],
              onChanged: (value) => setState(() => _role = value ?? _role),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _isSaving ? null : _inviteMember,
              icon: const Icon(Icons.send_outlined),
              label: _isSaving
                  ? const Text('Sending...')
                  : const Text('Send invitation'),
            ),
          ],
        ),
      ),
    );
  }
}
