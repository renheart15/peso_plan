import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_response_utils.dart';
import '../domain/transaction_model.dart';

class TransactionRepository {
  TransactionRepository({required this._api});

  final ApiClient _api;

  Future<List<TransactionModel>> getTransactions({required int? householdId}) async {
    if (householdId == null || householdId <= 0) {
      return _fallbackSampleTransactions();
    }

    try {
      final response = await _api.get<Map<String, dynamic>>(
        '/households/$householdId/transactions',
      );
      final payload = ApiResponseUtils.unwrapData(response.data);
      final rawList = ApiResponseUtils.unwrapCollection(payload);
      return rawList.map((item) => TransactionModel.fromJson(item)).toList();
    } catch (_) {
      return _fallbackSampleTransactions();
    }
  }

  Future<TransactionModel?> createTransaction({
    required int? householdId,
    required Map<String, dynamic> data,
  }) async {
    if (householdId == null || householdId <= 0) {
      final createdAt = DateTime.now();
      return TransactionModel(
        id: createdAt.millisecondsSinceEpoch,
        title: (data['payee'] ?? data['title'] ?? 'Transaction').toString(),
        category: (data['category'] ?? 'General').toString(),
        amountCents: _parseAmountCents(data['amount_cents'] ?? data['amount'] ?? 0),
        date: DateTime.tryParse(data['date']?.toString() ?? '') ?? createdAt,
        type: (data['type'] ?? 'expense').toString(),
        accountName: (data['account_name'] ?? data['account'] ?? 'Checking').toString(),
        notes: data['notes']?.toString(),
      );
    }

    try {
      final response = await _api.post<Map<String, dynamic>>(
        '/households/$householdId/transactions',
        data: data,
      );

      final payload = ApiResponseUtils.unwrapRecord(response.data) ?? data;
      return TransactionModel.fromJson(payload);
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> importCsv({
    required int householdId,
    required int accountId,
    required String filePath,
    required String fileName,
  }) async {
    try {
      final formData = FormData.fromMap({
        'account_id': accountId,
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });
      final response = await _api.post<Map<String, dynamic>>(
        '/households/$householdId/transactions/import',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      final data = ApiResponseUtils.unwrapRecord(response.data);
      return data?['imported'] == null ? null : data;
    } catch (_) {
      return null;
    }
  }

  int _parseAmountCents(Object? value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  List<TransactionModel> _fallbackSampleTransactions() {
    return [
      TransactionModel(
        id: 1,
        title: 'Salary deposit',
        category: 'Income',
        amountCents: 45000,
        date: DateTime(2026, 10, 1),
        type: 'income',
        accountName: 'Checking',
      ),
      TransactionModel(
        id: 2,
        title: 'Grocery run',
        category: 'Groceries',
        amountCents: -3250,
        date: DateTime(2026, 10, 3),
        type: 'expense',
        accountName: 'Cash',
      ),
      TransactionModel(
        id: 3,
        title: 'Electric bill',
        category: 'Utilities',
        amountCents: -2100,
        date: DateTime(2026, 10, 4),
        type: 'expense',
        accountName: 'Checking',
      ),
      TransactionModel(
        id: 4,
        title: 'Freelance project',
        category: 'Side hustle',
        amountCents: 12000,
        date: DateTime(2026, 10, 8),
        type: 'income',
        accountName: 'Savings',
      ),
    ];
  }
}
