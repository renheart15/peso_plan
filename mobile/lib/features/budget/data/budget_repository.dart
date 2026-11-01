import '../../../core/api/api_client.dart';
import '../../../core/api/api_response_utils.dart';
import '../domain/budget_category_model.dart';

class BudgetRepository {
  BudgetRepository({required this._api});

  final ApiClient _api;

  Future<List<BudgetCategoryModel>> getBudgetCategories({required int? householdId}) async {
    if (householdId == null || householdId <= 0) {
      return _fallbackSampleCategories();
    }

    try {
      final response = await _api.get<Map<String, dynamic>>(
        '/households/$householdId/budgets',
      );
      final payload = ApiResponseUtils.unwrapData(response.data);
      return ApiResponseUtils.unwrapCollection(payload)
          .map((item) => BudgetCategoryModel.fromJson(item))
          .toList();
    } catch (_) {
      return _fallbackSampleCategories();
    }
  }

  Future<BudgetCategoryModel?> createBudgetCategory({
    required int? householdId,
    required Map<String, dynamic> data,
  }) async {
    if (householdId == null || householdId <= 0) {
      return BudgetCategoryModel(
        id: DateTime.now().millisecondsSinceEpoch,
        name: (data['name'] ?? data['category_name'] ?? 'Category').toString(),
        plannedCents: _toInt(data['planned_cents'] ?? data['plannedCents'] ?? 0),
        spentCents: _toInt(data['spent_cents'] ?? data['spentCents'] ?? 0),
        iconName: data['icon']?.toString(),
        colorHex: data['color_hex']?.toString(),
      );
    }

    try {
      final response = await _api.post<Map<String, dynamic>>(
        '/households/$householdId/budgets',
        data: data,
      );
      final payload = ApiResponseUtils.unwrapRecord(response.data) ?? data;
      return BudgetCategoryModel.fromJson(payload);
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

  List<BudgetCategoryModel> _fallbackSampleCategories() {
    return [
      const BudgetCategoryModel(
        id: 1,
        name: 'Housing',
        plannedCents: 18500,
        spentCents: 7200,
        iconName: 'housing',
        colorHex: '#1A6B4A',
      ),
      const BudgetCategoryModel(
        id: 2,
        name: 'Groceries',
        plannedCents: 12000,
        spentCents: 9800,
        iconName: 'groceries',
        colorHex: '#0E7C86',
      ),
      const BudgetCategoryModel(
        id: 3,
        name: 'Transport',
        plannedCents: 5000,
        spentCents: 2900,
        iconName: 'transport',
        colorHex: '#3A86FF',
      ),
      const BudgetCategoryModel(
        id: 4,
        name: 'Utilities',
        plannedCents: 6500,
        spentCents: 3800,
        iconName: 'utilities',
        colorHex: '#B7791F',
      ),
      const BudgetCategoryModel(
        id: 5,
        name: 'Fun',
        plannedCents: 4000,
        spentCents: 1750,
        iconName: 'fun',
        colorHex: '#8A5CF6',
      ),
    ];
  }
}
