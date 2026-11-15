import '../../../core/api/api_client.dart';
import '../../../core/api/api_response_utils.dart';
import '../domain/recurring_bill_model.dart';

class RecurringBillRepository {
  RecurringBillRepository({required this._api});

  final ApiClient _api;

  Future<List<RecurringBillModel>> getRecurringBills({required int? householdId}) async {
    if (householdId == null || householdId <= 0) {
      return const [];
    }

    try {
      final response = await _api.get<Map<String, dynamic>>(
        '/households/$householdId/recurring-bills',
      );
      final payload = ApiResponseUtils.unwrapData(response.data);
      final rawList = ApiResponseUtils.unwrapCollection(payload);
      return rawList.map((item) => RecurringBillModel.fromJson(item)).toList();
    } catch (_) {
      rethrow;
    }
  }

  Future<RecurringBillModel?> createRecurringBill({
    required int? householdId,
    required Map<String, dynamic> data,
  }) async {
    if (householdId == null || householdId <= 0) {
      return RecurringBillModel(
        id: DateTime.now().millisecondsSinceEpoch,
        name: (data['name'] ?? 'Bill').toString(),
        amountCents: _toInt(data['amount_cents'] ?? data['amountCents'] ?? 0),
        frequency: (data['frequency'] ?? 'monthly').toString(),
        autoPay: data['auto_pay'] ?? data['autoPay'] ?? true,
        categoryName: (data['category_name'] ?? data['categoryName'] ?? 'Bills').toString(),
        nextDue: DateTime.tryParse(data['next_due']?.toString() ?? '') ?? DateTime.now().add(const Duration(days: 7)),
      );
    }

    try {
      final response = await _api.post<Map<String, dynamic>>(
        '/households/$householdId/recurring-bills',
        data: data,
      );
      final payload = ApiResponseUtils.unwrapRecord(response.data) ?? data;
      return RecurringBillModel.fromJson(payload);
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
