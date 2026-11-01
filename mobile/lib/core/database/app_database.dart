import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/users_table.dart';
import 'tables/households_table.dart';
import 'tables/accounts_table.dart';
import 'tables/categories_table.dart';
import 'tables/transactions_table.dart';
import 'tables/budgets_table.dart';
import 'tables/goals_table.dart';
import 'tables/recurring_bills_table.dart';
import 'tables/offline_queue_table.dart';

part 'app_database.g.dart';

/// Drift local database — offline cache and write queue.
@DriftDatabase(tables: [
  LocalUsers,
  LocalHouseholds,
  LocalAccounts,
  LocalCategories,
  LocalTransactions,
  LocalBudgets,
  LocalGoals,
  LocalRecurringBills,
  OfflineQueue,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'peso_plan');
  }
}
