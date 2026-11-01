import 'package:drift/drift.dart';

class LocalGoals extends Table {
  IntColumn get id => integer()();
  IntColumn get householdId => integer()();
  TextColumn get name => text()();
  IntColumn get targetCents => integer()();
  IntColumn get currentCents => integer()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  TextColumn get type => text()(); // savings | debt
  TextColumn get notes => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
