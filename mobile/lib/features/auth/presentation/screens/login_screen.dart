import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_text_field.dart';

// ── Error category ────────────────────────────────────────────────

enum _ErrorKind { none, retryable, nonRetryable, success }

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscure = true;
  bool _loading = false;
  String? _message;
  _ErrorKind _errorKind = _ErrorKind.none;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  String get _deviceName => Platform.isIOS ? 'iOS Device' : 'Android Device';

  // ── Error mapping ─────────────────────────────────────────────────

  ({String message, _ErrorKind kind}) _categoriseError(Object e) {
    if (e is DioException) {
      // Transport-level failures — backend may be waking up or unreachable.
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return (
          message:
              'The connection is taking too long. '
              'The server may be waking up — please try again.',
          kind: _ErrorKind.retryable,
        );
      }
      if (e.type == DioExceptionType.connectionError) {
        return (
          message:
              'Unable to connect to the server. '
              'Please check your internet connection.',
          kind: _ErrorKind.retryable,
        );
      }

      final status = e.response?.statusCode;
      final data = e.response?.data;

      // Extract validation error list (422).
      if (status == 422 && data is Map<String, dynamic>) {
        final errors = data['errors'];
        if (errors is Map<String, dynamic>) {
          final first = errors.values.firstOrNull;
          final msg = first is List && first.isNotEmpty
              ? first.first.toString()
              : 'Please check your email and password.';
          return (message: msg, kind: _ErrorKind.nonRetryable);
        }
      }

      if (status == 401) {
        return (
          message: 'Incorrect email or password. Please try again.',
          kind: _ErrorKind.nonRetryable,
        );
      }
      if (status == 404) {
        return (
          message: 'No account found with this email address.',
          kind: _ErrorKind.nonRetryable,
        );
      }
      if (status == 403) {
        return (
          message: 'Please verify your email address before logging in.',
          kind: _ErrorKind.nonRetryable,
        );
      }
      if (status == 429) {
        return (
          message:
              'Too many login attempts. Please wait a moment and try again.',
          kind: _ErrorKind.retryable,
        );
      }
      if (status != null && status >= 500) {
        return (
          message:
              'Our server is temporarily unavailable. '
              'Please try again in a moment.',
          kind: _ErrorKind.retryable,
        );
      }

      // Fallback with backend-provided message.
      if (data is Map<String, dynamic>) {
        final msg = data['message'] as String?;
        if (msg != null && msg.isNotEmpty) {
          return (message: msg, kind: _ErrorKind.nonRetryable);
        }
      }
    }

    return (
      message: 'An unexpected error occurred. Please try again.',
      kind: _ErrorKind.retryable,
    );
  }

  // ── Submission ────────────────────────────────────────────────────

  Future<void> _submit() async {
    // Validate empty fields before hitting the network.
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _message = 'Please enter your email and password.';
        _errorKind = _ErrorKind.nonRetryable;
      });
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _message = null;
      _errorKind = _ErrorKind.none;
    });

    try {
      await ref
          .read(authStateProvider.notifier)
          .login(
            email: email,
            password: password,
            deviceName: _deviceName,
          );

      // Show a brief success message; GoRouter will navigate away when
      // authState.isLoggedIn becomes true.
      if (mounted) {
        setState(() {
          _message = 'Login successful! Welcome back.';
          _errorKind = _ErrorKind.success;
          _loading = false;
        });
      }
    } catch (e) {
      final result = _categoriseError(e);
      if (mounted) {
        setState(() {
          _message = result.message;
          _errorKind = result.kind;
        });
      }
    } finally {
      if (mounted && _errorKind != _ErrorKind.success) {
        setState(() => _loading = false);
      }
    }
  }

  // ── Build ─────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthLogo(),
                const SizedBox(height: 40),
                Text(
                  'Welcome back',
                  style: tt.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Sign in to your Peso Plan account',
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),

                // ── Status banner ─────────────────────────────────
                if (_message != null) ...[
                  _StatusBanner(
                    message: _message!,
                    kind: _errorKind,
                    onRetry: _errorKind == _ErrorKind.retryable
                        ? _submit
                        : null,
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Fields ────────────────────────────────────────
                AuthTextField(
                  controller: _emailCtrl,
                  label: 'Email address',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  autofillHints: const [AutofillHints.email],
                  prefixIcon: const Icon(Icons.email_outlined),
                  onChanged: (_) => _clearMessageIfNeeded(),
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
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _passwordCtrl,
                  label: 'Password',
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  onChanged: (_) => _clearMessageIfNeeded(),
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                    tooltip: _obscure ? 'Show password' : 'Hide password',
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(AppRoutes.forgotPassword),
                    child: const Text('Forgot password?'),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Sign-in button ────────────────────────────────
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
                      : const Text('Sign in'),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: tt.bodyMedium),
                    TextButton(
                      onPressed: () =>
                          context.pushReplacement(AppRoutes.register),
                      child: const Text('Create one'),
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

  void _clearMessageIfNeeded() {
    if (_message != null && _errorKind != _ErrorKind.success) {
      setState(() {
        _message = null;
        _errorKind = _ErrorKind.none;
      });
    }
  }
}

// ── Status banner widget ──────────────────────────────────────────

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.message,
    required this.kind,
    this.onRetry,
  });

  final String message;
  final _ErrorKind kind;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final (Color bg, Color fg, IconData icon) = switch (kind) {
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
      _ => (cs.errorContainer, cs.onErrorContainer, Icons.error_outline),
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: fg, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: tt.bodySmall?.copyWith(color: fg),
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onRetry,
                    child: Text(
                      'Tap to retry',
                      style: tt.labelSmall?.copyWith(
                        color: fg,
                        decoration: TextDecoration.underline,
                        decorationColor: fg,
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
