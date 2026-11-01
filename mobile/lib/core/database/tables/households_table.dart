import 'package:drift/drift.dart';

class LocalHouseholds extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get role => text()(); // owner | partner | viewer
  DateTimeColumn get syncedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
