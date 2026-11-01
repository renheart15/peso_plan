import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/verify_email_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/budget/presentation/screens/budget_screen.dart';
import '../../features/budget/presentation/screens/add_budget_screen.dart';
import '../../features/transactions/presentation/screens/transactions_screen.dart';
import '../../features/transactions/presentation/screens/add_transaction_screen.dart';
import '../../features/transactions/presentation/screens/auto_categorization_screen.dart';
import '../../features/goals/presentation/screens/goals_screen.dart';
import '../../features/goals/presentation/screens/add_goal_screen.dart';
import '../../features/recurring/presentation/screens/recurring_bills_screen.dart';
import '../../features/recurring/presentation/screens/add_recurring_bill_screen.dart';
import '../../features/goals/presentation/screens/debt_payoff_screen.dart';
import '../../features/accounts/presentation/screens/accounts_screen.dart';
import '../../features/accounts/presentation/screens/add_account_screen.dart';
import '../../features/reports/presentation/screens/reports_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/notifications_screen.dart';
import '../../features/settings/presentation/screens/export_screen.dart';
import '../../features/settings/presentation/screens/sync_queue_screen.dart';
import '../../features/settings/presentation/screens/accessibility_screen.dart';
import '../../features/settings/presentation/screens/app_info_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/household/presentation/screens/household_screen.dart';
import '../../features/household/presentation/screens/invite_member_screen.dart';
import '../providers/app_providers.dart';
import '../widgets/main_scaffold.dart';

/// Named routes
class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const verifyEmail = '/verify-email';
  static const dashboard = '/dashboard';
  static const budget = '/budget';
  static const addBudget = '/budget/add';
  static const transactions = '/transactions';
  static const addTransaction = '/transactions/add';
  static const autoCategorization = '/transactions/auto-categorize';
  static const editTransaction = '/transactions/edit/:id';
  static const goals = '/goals';
  static const addGoal = '/goals/add';
  static const debtPayoff = '/goals/debt-payoff';
  static const accounts = '/accounts';
  static const addAccount = '/accounts/add';
  static const reports = '/reports';
  static const settings = '/settings';
  static const notifications = '/settings/notifications';
  static const exportData = '/settings/export-data';
  static const syncQueue = '/settings/sync-queue';
  static const accessibility = '/settings/accessibility';
  static const appInfo = '/settings/app-info';
  static const household = '/household';
  static const inviteMember = '/household/invite';
  static const recurringBills = '/recurring-bills';
  static const addRecurringBill = '/recurring-bills/add';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = authState.isLoggedIn;
      final isOnAuth =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register ||
          state.matchedLocation == AppRoutes.forgotPassword;
      final isOnboarding = state.matchedLocation == AppRoutes.onboarding;

      if (!isLoggedIn && !isOnAuth && !isOnboarding) {
        return AppRoutes.login;
      }

      if (isLoggedIn &&
          (isOnAuth || state.matchedLocation == AppRoutes.splash)) {
        // First time users go to onboarding
        if (authState.isFirstLogin) return AppRoutes.onboarding;
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      // ── Auth shell ──────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (c, s) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (c, s) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (c, s) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        name: 'verifyEmail',
        builder: (c, s) => const VerifyEmailScreen(),
      ),

      // ── Onboarding ──────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (c, s) => const OnboardingScreen(),
      ),

      // ── Main app shell with bottom nav ──────────────────────────
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            builder: (c, s) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.budget,
            name: 'budget',
            builder: (c, s) => const BudgetScreen(),
            routes: [
              GoRoute(
                path: 'add',
                name: 'addBudget',
                builder: (c, s) => const AddBudgetScreen(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.transactions,
            name: 'transactions',
            builder: (c, s) => const TransactionsScreen(),
            routes: [
              GoRoute(
                path: 'add',
                name: 'addTransaction',
                builder: (c, s) => const AddTransactionScreen(),
              ),
              GoRoute(
                path: 'auto-categorize',
                name: 'autoCategorization',
                builder: (c, s) => const AutoCategorizationScreen(),
              ),
              GoRoute(
                path: 'edit/:id',
                name: 'editTransaction',
                builder: (c, s) => AddTransactionScreen(
                  transactionId: int.tryParse(s.pathParameters['id'] ?? ''),
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.goals,
            name: 'goals',
            builder: (c, s) => const GoalsScreen(),
            routes: [
              GoRoute(
                path: 'add',
                name: 'addGoal',
                builder: (c, s) => const AddGoalScreen(),
              ),
              GoRoute(
                path: 'debt-payoff',
                name: 'debtPayoff',
                builder: (c, s) => const DebtPayoffScreen(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.accounts,
            name: 'accounts',
            builder: (c, s) => const AccountsScreen(),
            routes: [
              GoRoute(
                path: 'add',
                name: 'addAccount',
                builder: (c, s) => const AddAccountScreen(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.reports,
            name: 'reports',
            builder: (c, s) => const ReportsScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            builder: (c, s) => const SettingsScreen(),
            routes: [
              GoRoute(
                path: 'notifications',
                name: 'notifications',
                builder: (c, s) => const NotificationsScreen(),
              ),
              GoRoute(
                path: 'export-data',
                name: 'exportData',
                builder: (c, s) => const ExportScreen(),
              ),
              GoRoute(
                path: 'sync-queue',
                name: 'syncQueue',
                builder: (c, s) => const SyncQueueScreen(),
              ),
              GoRoute(
                path: 'accessibility',
                name: 'accessibility',
                builder: (c, s) => const AccessibilityScreen(),
              ),
              GoRoute(
                path: 'app-info',
                name: 'appInfo',
                builder: (c, s) => const AppInfoScreen(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.household,
            name: 'household',
            builder: (c, s) => const HouseholdScreen(),
            routes: [
              GoRoute(
                path: 'invite',
                name: 'inviteMember',
                builder: (c, s) => const InviteMemberScreen(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.recurringBills,
            name: 'recurringBills',
            builder: (c, s) => const RecurringBillsScreen(),
            routes: [
              GoRoute(
                path: 'add',
                name: 'addRecurringBill',
                builder: (c, s) => const AddRecurringBillScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}'),
          ],
        ),
      ),
    ),
  );
});
