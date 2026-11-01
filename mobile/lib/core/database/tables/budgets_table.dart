import 'package:drift/drift.dart';

class LocalBudgets extends Table {
  IntColumn get id => integer()();
  IntColumn get householdId => integer()();
  IntColumn get categoryId => integer()();
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  IntColumn get plannedCents => integer()();
  DateTimeColumn get syncedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
