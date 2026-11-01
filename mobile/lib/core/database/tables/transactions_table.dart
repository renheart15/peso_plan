import 'package:drift/drift.dart';

class LocalTransactions extends Table {
  IntColumn get id => integer()();
  IntColumn get householdId => integer()();
  IntColumn get accountId => integer()();
  IntColumn get categoryId => integer().nullable()();
  IntColumn get amountCents => integer()(); // always positive; type field determines sign
  TextColumn get type => text()(); // income | expense | transfer
  DateTimeColumn get date => dateTime()();
  TextColumn get payee => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get importHash => text().nullable()();
  IntColumn get createdBy => integer()();
  BoolColumn get isPending => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
