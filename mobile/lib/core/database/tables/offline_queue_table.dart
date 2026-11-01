import 'package:drift/drift.dart';

/// Queue for writes made while offline. Replayed on reconnect.
class OfflineQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get method => text()(); // POST | PUT | PATCH | DELETE
  TextColumn get path => text()(); // API path
  TextColumn get body => text().nullable()(); // JSON-encoded body
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
  TextColumn get errorMessage => text().nullable()();
  BoolColumn get isFailed => boolean().withDefault(const Constant(false))();
}
