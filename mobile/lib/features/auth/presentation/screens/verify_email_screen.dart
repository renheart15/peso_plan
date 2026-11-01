import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';

class VerifyEmailScreen extends ConsumerWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Verify email')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mail_outline, size: 80, color: cs.primary),
            const SizedBox(height: 24),
            Text('Check your inbox', style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.w700), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(
              'We\'ve sent a verification link to ${authState.userEmail ?? 'your email'}. Click it to verify your account.',
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () async {
                try {
                  await ref.read(authRepositoryProvider).resendVerificationEmail();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Verification email resent.')),
                    );
                  }
                } catch (_) {}
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Resend verification email'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => ref.read(authStateProvider.notifier).logout(),
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
