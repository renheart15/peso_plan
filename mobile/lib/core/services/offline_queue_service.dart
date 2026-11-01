import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';

import '../api/api_client.dart';
import '../database/app_database.dart';

class OfflineQueueService {
  OfflineQueueService(this._db, [ApiClient? apiClient]) : _apiClient = apiClient;

  final AppDatabase _db;
  final ApiClient? _apiClient;

  Stream<List<OfflineQueueData>> watchQueue() {
    final query = _db.select(_db.offlineQueue)
      ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]);
    return query.watch();
  }

  Future<void> enqueue({
    required String method,
    required String path,
    String? body,
    int retryCount = 0,
  }) async {
    await _db.into(_db.offlineQueue).insert(
      OfflineQueueCompanion.insert(
        method: method,
        path: path,
        body: body == null ? const Value.absent() : Value(body),
        retryCount: Value(retryCount),
      ),
    );
  }

  Future<void> markRetry({required int id, required String? errorMessage}) async {
    final item = await (_db.select(_db.offlineQueue)
          ..where((row) => row.id.equals(id)))
        .getSingle();

    await (_db.update(_db.offlineQueue)
          ..where((row) => row.id.equals(id)))
        .write(
      OfflineQueueCompanion(
        retryCount: Value(item.retryCount + 1),
        lastAttemptAt: Value(DateTime.now()),
        errorMessage: Value(errorMessage),
        isFailed: const Value(false),
      ),
    );
  }

  Future<void> markFailed({
    required int id,
    required String errorMessage,
    bool keepForRetry = true,
  }) async {
    await (_db.update(_db.offlineQueue)
          ..where((row) => row.id.equals(id)))
        .write(
      OfflineQueueCompanion(
        isFailed: Value(!keepForRetry),
        errorMessage: Value(errorMessage),
        lastAttemptAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> syncAll({int maxAttempts = 25}) async {
    var syncedCount = 0;

    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final item = await _nextPendingItem();
      if (item == null) {
        break;
      }

      final didSync = await _syncItem(item);
      if (!didSync) {
        break;
      }

      syncedCount += 1;
    }

    return syncedCount;
  }

  Future<OfflineQueueData?> _nextPendingItem() async {
    final items = await (_db.select(_db.offlineQueue)
          ..where((row) => row.isFailed.equals(false))
          ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
        .get();

    if (items.isEmpty) {
      return null;
    }

    return items.first;
  }

  Future<bool> _syncItem(OfflineQueueData item) async {
    final apiClient = _apiClient;
    if (apiClient == null) {
      return false;
    }

    try {
      await apiClient.dio.request(
        item.path,
        data: _decodeBody(item.body),
        options: Options(method: item.method),
      );
      await (_db.delete(_db.offlineQueue)
            ..where((row) => row.id.equals(item.id)))
          .go();
      return true;
    } on DioException catch (error) {
      final message = dioErrorMessage(error);
      if (item.retryCount >= 3) {
        await markFailed(id: item.id, errorMessage: message, keepForRetry: false);
      } else {
        await markRetry(id: item.id, errorMessage: message);
      }
      return false;
    } catch (error) {
      await markFailed(
        id: item.id,
        errorMessage: error.toString(),
        keepForRetry: false,
      );
      return false;
    }
  }

  dynamic _decodeBody(String? body) {
    if (body == null || body.trim().isEmpty) {
      return null;
    }

    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  Future<void> clearCompleted({required List<int> ids}) async {
    if (ids.isEmpty) return;

    await (_db.delete(_db.offlineQueue)
          ..where((row) => row.id.isIn(ids)))
        .go();
  }
}
