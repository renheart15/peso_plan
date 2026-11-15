/// App-wide constants for Peso Plan.
library;

import 'dart:io';

class AppConstants {
  AppConstants._();

  // ── API ─────────────────────────────────────────────────────────
  /// Override at build time via --dart-define=API_BASE_URL=...
  /// Default points to the production Render backend so release builds
  /// work without any extra dart-define flags.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://peso-plan-api.onrender.com/api/v1',
  );

  static const String apiVersion = 'v1';
  /// Main API request timeout — generous enough for Render's free-tier cold start.
  static const int apiTimeoutSeconds = 60;

  /// Per-attempt timeout used when probing the backend /up health endpoint.
  static const int warmUpReceiveTimeoutSeconds = 25;

  /// Maximum warm-up probe attempts before giving up.
  static const int warmUpMaxAttempts = 4;

  /// Seconds to wait between warm-up attempts.
  static const int warmUpDelaySeconds = 8;

  // ── Secure Storage keys ─────────────────────────────────────────
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyHouseholdId = 'household_id';
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyBudgetMode = 'budget_mode';
  static const String keyCurrencyCode = 'currency_code';
  static const String keyLocale = 'locale';
  static const String keyThemeMode = 'theme_mode';

  // ── Defaults ────────────────────────────────────────────────────
  static const String defaultCurrency = 'PHP';
  static const String defaultLocale = 'en_PH';
  static const String defaultBudgetMode = 'simple'; // 'simple' | 'zero_based'

  // ── Money ────────────────────────────────────────────────────────
  /// All monetary values are stored and transmitted as integer cents.
  static const int centsPerUnit = 100;

  // ── Pagination ───────────────────────────────────────────────────
  static const int defaultPageSize = 25;

  // ── Offline sync ─────────────────────────────────────────────────
  static const Duration syncDebounce = Duration(seconds: 2);
  static const Duration offlineQueueRetryInterval = Duration(minutes: 5);

  // ── Notifications ────────────────────────────────────────────────
  static const String fcmTopicPrefix = 'peso_plan';
  static const int notifChannelIdBudget = 1001;
  static const int notifChannelIdBill = 1002;
  static const int notifChannelIdGoal = 1003;

  // ── Budget modes ─────────────────────────────────────────────────
  static const String budgetModeSimple = 'simple';
  static const String budgetModeZeroBased = 'zero_based';

  // ── Household roles ──────────────────────────────────────────────
  static const String roleOwner = 'owner';
  static const String rolePartner = 'partner';
  static const String roleViewer = 'viewer';

  // ── Account types ────────────────────────────────────────────────
  static const List<String> accountTypes = [
    'checking',
    'savings',
    'credit_card',
    'cash',
    'loan',
  ];

  // ── Category types ───────────────────────────────────────────────
  static const String categoryIncome = 'income';
  static const String categoryExpense = 'expense';

  // ── Goal types ───────────────────────────────────────────────────
  static const String goalSavings = 'savings';
  static const String goalDebt = 'debt';

  // ── Frequency types ─────────────────────────────────────────────
  static const List<String> recurringFrequencies = [
    'daily',
    'weekly',
    'biweekly',
    'monthly',
    'quarterly',
    'yearly',
  ];
}

/// Build-time flavor enum
enum AppFlavor { dev, staging, production }

class FlavorConfig {
  static AppFlavor get flavor {
    const name = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    return AppFlavor.values.firstWhere(
      (f) => f.name == name,
      orElse: () => AppFlavor.dev,
    );
  }

  static String get apiBaseUrl {
    // If a custom URL was injected at build time (e.g. for local dev), use it.
    const injected = String.fromEnvironment('API_BASE_URL');
    if (injected.isNotEmpty) return injected;

    return switch (flavor) {
      // Local development (emulator / physical device via USB)
      AppFlavor.dev => Platform.isAndroid
          ? 'http://10.0.2.2:8000/api/v1'
          : 'http://127.0.0.1:8000/api/v1',
      // All other flavors use the production Render URL.
      AppFlavor.staging ||
      AppFlavor.production =>
        'https://peso-plan-api.onrender.com/api/v1',
    };
  }

  static bool get showDebugBanner => flavor == AppFlavor.dev;
}
