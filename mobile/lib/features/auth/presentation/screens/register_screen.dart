import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/api/api_client.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_text_field.dart';

// ── Error classification ─────────────────────────────────────────────────────

enum _ErrorKind { none, retryable, nonRetryable, success }

class _Status {
  const _Status(this.kind, this.message);
  final _ErrorKind kind;
  final String message;
  static const none = _Status(_ErrorKind.none, '');
}

_Status _categoriseError(Object e) {
  if (e is DioException) {
    // Network / transport
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const _Status(
        _ErrorKind.retryable,
        'The connection is taking too long. Please try again.',
      );
    }
    if (e.type == DioExceptionType.connectionError) {
      return const _Status(
        _ErrorKind.retryable,
        'Unable to connect to the server. Please check your internet connection.',
      );
    }

    final status = e.response?.statusCode;
    final data = e.response?.data;

    // Laravel validation errors (422) — show first field error
    if (data is Map<String, dynamic> && data.containsKey('errors')) {
      final errors = data['errors'] as Map<String, dynamic>;
      final first = errors.values.firstOrNull;
      final msg =
          (first is List && first.isNotEmpty)
              ? first.first.toString()
              : errors.values
                  .expand((v) => v is List ? v.cast<String>() : [v.toString()])
                  .first;
      return _Status(_ErrorKind.nonRetryable, msg);
    }

    // Other backend message (not 401)
    if (data is Map<String, dynamic>) {
      final backendMsg = data['message'] as String?;
      if (backendMsg != null && backendMsg.isNotEmpty && status != 401) {
        return _Status(_ErrorKind.nonRetryable, backendMsg);
      }
    }

    return _Status(
      _ErrorKind.nonRetryable,
      switch (status) {
        400 => 'Bad request. Please check your input.',
        401 => 'Incorrect email or password. Please try again.',
        409 => 'An account with this email already exists.',
        422 => 'Validation error. Please check your input.',
        429 => 'Too many attempts. Please slow down and try again later.',
        500 || 502 || 503 || 504 =>
          'Our server is temporarily unavailable. Please try again in a moment.',
        _ => dioErrorMessage(e),
      },
    );
  }

  // Catch-all for non-Dio errors (e.g. type cast failures)
  final raw = e.toString().replaceFirst('Exception: ', '');
  return _Status(_ErrorKind.nonRetryable, raw);
}

// ── Status banner widget ─────────────────────────────────────────────────────

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.status, this.onRetry});
  final _Status status;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final (bg, fg, icon) = switch (status.kind) {
      _ErrorKind.success => (
        cs.primaryContainer,
        cs.onPrimaryContainer,
        Icons.check_circle_outline,
      ),
      _ErrorKind.retryable => (
        cs.tertiaryContainer,
        cs.onTertiaryContainer,
        Icons.wifi_off_outlined,
      ),
      _ErrorKind.nonRetryable => (
        cs.errorContainer,
        cs.onErrorContainer,
        Icons.error_outline,
      ),
      _ErrorKind.none => (Colors.transparent, Colors.transparent, Icons.info),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: fg),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.message,
                  style: tt.bodySmall?.copyWith(color: fg),
                ),
                if (status.kind == _ErrorKind.retryable && onRetry != null) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: onRetry,
                    child: Text(
                      'Tap to retry',
                      style: tt.bodySmall?.copyWith(
                        color: fg,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Register screen ──────────────────────────────────────────────────────────

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _householdCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  _Status _status = _Status.none;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _householdCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String get _deviceName => Platform.isIOS ? 'iOS Device' : 'Android Device';

  /// Clears the status banner whenever the user edits any field.
  void _onChanged() {
    if (_status.kind != _ErrorKind.none) {
      setState(() => _status = _Status.none);
    }
  }

  Future<void> _submit() async {
    // Clear any previous message first
    setState(() => _status = _Status.none);

    if (!_formKey.currentState!.validate()) return;

    // Guard against empty fields (belt-and-suspenders)
    if (_nameCtrl.text.trim().isEmpty ||
        _emailCtrl.text.trim().isEmpty ||
        _passwordCtrl.text.isEmpty ||
        _confirmCtrl.text.isEmpty) {
      setState(() => _status = const _Status(
            _ErrorKind.nonRetryable,
            'Please fill in all required fields.',
          ));
      return;
    }

    setState(() => _loading = true);

    try {
      await ref
          .read(authStateProvider.notifier)
          .register(
            name: _nameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text,
            passwordConfirmation: _confirmCtrl.text,
            householdName: _householdCtrl.text.trim(),
            deviceName: _deviceName,
          );

      // Show success message briefly before the router redirects.
      if (mounted) {
        setState(() {
          _loading = false;
          _status = const _Status(
            _ErrorKind.success,
            'Account created! Welcome to Peso Plan 🎉',
          );
        });
      }

      // The GoRouter redirect will fire automatically once isLoggedIn == true,
      // but we give the user a moment to see the success message.
      await Future<void>.delayed(const Duration(milliseconds: 1200));
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _status = _categoriseError(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthLogo(),
                const SizedBox(height: 32),
                Text(
                  'Create your account',
                  style: tt.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Start managing your budget with Peso Plan',
                  style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 28),

                // ── Status banner ──────────────────────────────────────
                if (_status.kind != _ErrorKind.none) ...[
                  _StatusBanner(
                    status: _status,
                    onRetry:
                        _status.kind == _ErrorKind.retryable ? _submit : null,
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Form fields ────────────────────────────────────────
                AuthTextField(
                  controller: _nameCtrl,
                  label: 'Full name',
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  prefixIcon: const Icon(Icons.person_outlined),
                  onChanged: (_) => _onChanged(),
                  validator: (v) {
                    final name = v?.trim() ?? '';
                    if (name.isEmpty) return 'Full name is required';
                    if (name.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    if (name.length > 255) return 'Name is too long';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: _emailCtrl,
                  label: 'Email address',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  autofillHints: const [AutofillHints.email],
                  prefixIcon: const Icon(Icons.email_outlined),
                  onChanged: (_) => _onChanged(),
                  validator: (v) {
                    final email = v?.trim() ?? '';
                    if (email.isEmpty) return 'Email is required';
                    if (email.length > 254) return 'Email is too long';
                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                        .hasMatch(email)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: _householdCtrl,
                  label: 'Household name',
                  hintText: 'e.g. The Santos Family',
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.home_outlined),
                  onChanged: (_) => _onChanged(),
                  validator: (v) {
                    final household = v?.trim() ?? '';
                    if (household.isEmpty) return 'Household name is required';
                    if (household.length < 2) {
                      return 'Household name must be at least 2 characters';
                    }
                    if (household.length > 255) {
                      return 'Household name is too long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: _passwordCtrl,
                  label: 'Password',
                  obscureText: _obscure,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  prefixIcon: const Icon(Icons.lock_outlined),
                  onChanged: (_) => _onChanged(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    if (v.length > 72) return 'Password is too long';
                    if (!RegExp(r'[A-Za-z]').hasMatch(v) ||
                        !RegExp(r'\d').hasMatch(v)) {
                      return 'Password must contain letters and numbers';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: _confirmCtrl,
                  label: 'Confirm password',
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.newPassword],
                  onFieldSubmitted: (_) => _submit(),
                  onChanged: (_) => _onChanged(),
                  prefixIcon: const Icon(Icons.lock_outlined),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Confirm your password';
                    if (v != _passwordCtrl.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // ── Submit button ──────────────────────────────────────
                FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Create account'),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ', style: tt.bodyMedium),
                    TextButton(
                      onPressed: () => context.pushReplacement(AppRoutes.login),
                      child: const Text('Sign in'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
