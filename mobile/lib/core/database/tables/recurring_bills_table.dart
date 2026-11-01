import 'package:drift/drift.dart';

class LocalRecurringBills extends Table {
  IntColumn get id => integer()();
  IntColumn get householdId => integer()();
  TextColumn get name => text()();
  IntColumn get amountCents => integer()();
  TextColumn get frequency => text()(); // daily | weekly | biweekly | monthly | quarterly | yearly
  DateTimeColumn get nextDue => dateTime()();
  IntColumn get categoryId => integer().nullable()();
  BoolColumn get autoPay => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
