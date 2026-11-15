// ignore_for_file: prefer_initializing_formals

import '../../../core/api/api_client.dart';
import '../../../core/api/api_response_utils.dart';
import '../domain/account_model.dart';

class AccountRepository {
  AccountRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  Future<List<AccountModel>> getAccounts({required int? householdId}) async {
    if (householdId == null || householdId <= 0) {
      return const [];
    }

    try {
      final response = await _api.get<Map<String, dynamic>>(
        '/households/$householdId/accounts',
      );
      final payload = ApiResponseUtils.unwrapData(response.data);
      final rawList = ApiResponseUtils.unwrapCollection(payload);
      return rawList.map((item) => AccountModel.fromJson(item)).toList();
    } catch (_) {
      rethrow;
    }
  }

  Future<AccountModel?> createAccount({
    required int? householdId,
    required Map<String, dynamic> data,
  }) async {
    if (householdId == null || householdId <= 0) {
      return AccountModel(
        id: DateTime.now().millisecondsSinceEpoch,
        name: (data['name'] ?? 'Account').toString(),
        balanceCents: _toInt(data['balance_cents'] ?? data['balance'] ?? 0),
        type: (data['type'] ?? 'checking').toString(),
        lastUpdated: DateTime.now(),
      );
    }

    try {
      final response = await _api.post<Map<String, dynamic>>(
        '/households/$householdId/accounts',
        data: data,
      );
      final payload = ApiResponseUtils.unwrapRecord(response.data) ?? data;
      return AccountModel.fromJson(payload);
    } catch (_) {
      return null;
    }
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

}
