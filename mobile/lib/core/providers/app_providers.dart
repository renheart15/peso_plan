import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../api/api_client.dart';
import '../constants/app_constants.dart';
import '../database/app_database.dart';
import '../services/notification_service.dart';
import '../services/offline_queue_service.dart';
import '../../features/accounts/data/account_repository.dart';
import '../../features/accounts/domain/account_model.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/domain/auth_state.dart';
import '../../features/budget/data/budget_repository.dart';
import '../../features/budget/domain/budget_category_model.dart';
import '../../features/goals/data/goal_repository.dart';
import '../../features/goals/domain/goal_model.dart';
import '../../features/household/data/household_repository.dart';
import '../../features/household/domain/household_summary_model.dart';
import '../../features/recurring/data/recurring_bill_repository.dart';
import '../../features/recurring/domain/recurring_bill_model.dart';
import '../../features/reports/data/report_repository.dart';
import '../../features/reports/domain/report_summary_model.dart';
import '../../features/transactions/data/transaction_repository.dart';
import '../../features/transactions/domain/transaction_model.dart';

// ── Secure Storage ───────────────────────────────────────────────

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (_) => const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  ),
);

// ── API Client ───────────────────────────────────────────────────

final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return ApiClient(storage: storage);
});

// ── Auth ─────────────────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthRepository(api: api, storage: storage);
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});

// ── Theme ─────────────────────────────────────────────────────────

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system);

  void setMode(ThemeMode mode) => state = mode;
}

// ── Currency & Locale ────────────────────────────────────────────

final currencyCodeProvider = StateProvider<String>(
  (_) => AppConstants.defaultCurrency,
);
final localeProvider = StateProvider<Locale>((_) => const Locale('en', 'PH'));

// ── Budget Mode ───────────────────────────────────────────────────

final budgetModeProvider = StateProvider<String>(
  (_) => AppConstants.budgetModeSimple,
);

// ── Connectivity ─────────────────────────────────────────────────

final connectivityOnlineProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  bool isOnline(List<ConnectivityResult> results) =>
      results.isNotEmpty && !results.every((result) => result == ConnectivityResult.none);

  yield isOnline(await connectivity.checkConnectivity());
  await for (final results in connectivity.onConnectivityChanged) {
    yield isOnline(results);
  }
});

final isOnlineProvider = StateProvider<bool>((_) => true);

final notificationServiceProvider = Provider<AppNotificationService>(
  (_) => AppNotificationService(),
);

final appDatabaseProvider = Provider<AppDatabase>((_) => AppDatabase());

final offlineQueueServiceProvider = Provider<OfflineQueueService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final api = ref.watch(apiClientProvider);
  return OfflineQueueService(db, api);
});

final offlineQueueProvider = StreamProvider<List<OfflineQueueData>>((ref) {
  final service = ref.watch(offlineQueueServiceProvider);
  return service.watchQueue();
});

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  return AccountRepository(api: api);
});

final accountsProvider = FutureProvider<List<AccountModel>>((ref) async {
  final repo = ref.watch(accountRepositoryProvider);
  final householdId = ref.watch(authStateProvider).householdId;
  return repo.getAccounts(householdId: householdId);
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  return TransactionRepository(api: api);
});

final transactionsProvider = FutureProvider<List<TransactionModel>>((ref) async {
  final repo = ref.watch(transactionRepositoryProvider);
  final householdId = ref.watch(authStateProvider).householdId;
  return repo.getTransactions(householdId: householdId);
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  return BudgetRepository(api: api);
});

final budgetCategoriesProvider = FutureProvider<List<BudgetCategoryModel>>((ref) async {
  final repo = ref.watch(budgetRepositoryProvider);
  final householdId = ref.watch(authStateProvider).householdId;
  return repo.getBudgetCategories(householdId: householdId);
});

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  return GoalRepository(api: api);
});

final goalsProvider = FutureProvider<List<GoalModel>>((ref) async {
  final repo = ref.watch(goalRepositoryProvider);
  final householdId = ref.watch(authStateProvider).householdId;
  return repo.getGoals(householdId: householdId);
});

final recurringBillRepositoryProvider = Provider<RecurringBillRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  return RecurringBillRepository(api: api);
});

final recurringBillsProvider = FutureProvider<List<RecurringBillModel>>((ref) async {
  final repo = ref.watch(recurringBillRepositoryProvider);
  final householdId = ref.watch(authStateProvider).householdId;
  return repo.getRecurringBills(householdId: householdId);
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  return ReportRepository(api: api);
});

final reportSummaryProvider = FutureProvider<ReportSummaryModel>((ref) async {
  final repo = ref.watch(reportRepositoryProvider);
  final householdId = ref.watch(authStateProvider).householdId;
  return repo.getReportSummary(householdId: householdId);
});

final householdRepositoryProvider = Provider<HouseholdRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  return HouseholdRepository(api: api);
});

final householdSummaryProvider = FutureProvider<HouseholdSummaryModel>((ref) async {
  final repo = ref.watch(householdRepositoryProvider);
  final householdId = ref.watch(authStateProvider).householdId;
  return repo.getHouseholdSummary(householdId: householdId);
});
