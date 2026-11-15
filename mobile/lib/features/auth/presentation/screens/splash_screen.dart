import 'package:flutter/material.dart';

/// Shown while [AuthNotifier] resolves the initial session state on startup.
///
/// The router automatically redirects away from this screen once
/// [AuthState.isInitializing] becomes [false].
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.savings_outlined,
                size: 72,
                color: cs.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Peso Plan',
                style: tt.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.primary,
                ),
              ),
              const SizedBox(height: 56),
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(height: 20),
              Text(
                'Connecting to server\u2026',
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

