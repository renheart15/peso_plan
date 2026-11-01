import 'package:drift/drift.dart';

class LocalAccounts extends Table {
  IntColumn get id => integer()();
  IntColumn get householdId => integer()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // checking | savings | credit_card | cash | loan
  IntColumn get balanceCents => integer().withDefault(const Constant(0))();
  TextColumn get currencyCode => text().withDefault(const Constant('PHP'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get syncedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
