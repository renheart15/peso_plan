import '../../../core/api/api_client.dart';
import '../../../core/api/api_response_utils.dart';
import '../domain/budget_category_model.dart';

class BudgetRepository {
  BudgetRepository({required this._api});

  final ApiClient _api;

  Future<List<BudgetCategoryModel>> getBudgetCategories({
    required int? householdId,
  }) async {
    if (householdId == null || householdId <= 0) {
      return const [];
    }

    try {
      final now = DateTime.now();
      final response = await _api.get<Map<String, dynamic>>(
        '/households/$householdId/budgets',
        queryParameters: {'year': now.year, 'month': now.month},
      );
      final payload = ApiResponseUtils.unwrapData(response.data);
      return ApiResponseUtils.unwrapCollection(payload)
          .map((item) => BudgetCategoryModel.fromJson(item))
          .toList();
    } catch (_) {
      rethrow;
    }
  }

  Future<BudgetCategoryModel?> createBudgetCategory({
    required int? householdId,
    required Map<String, dynamic> data,
  }) async {
    if (householdId == null || householdId <= 0) return null;

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

  Future<BudgetCategoryModel?> updateBudget({
    required int householdId,
    required int budgetId,
    required int plannedCents,
  }) async {
    try {
      final response = await _api.put<Map<String, dynamic>>(
        '/households/$householdId/budgets/$budgetId',
        data: {'planned_cents': plannedCents},
      );
      final payload = ApiResponseUtils.unwrapRecord(response.data);
      return payload == null ? null : BudgetCategoryModel.fromJson(payload);
    } catch (_) {
      return null;
    }
  }

  Future<bool> deleteBudget({
    required int householdId,
    required int budgetId,
  }) async {
    try {
      await _api.delete<void>('/households/$householdId/budgets/$budgetId');
      return true;
    } catch (_) {
      return false;
    }
  }
}
