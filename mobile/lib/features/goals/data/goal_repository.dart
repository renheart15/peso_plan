import '../../../core/api/api_client.dart';
import '../../../core/api/api_response_utils.dart';
import '../domain/goal_model.dart';

class GoalRepository {
  GoalRepository({required this._api});

  final ApiClient _api;

  Future<List<GoalModel>> getGoals({required int? householdId}) async {
    if (householdId == null || householdId <= 0) {
      return _fallbackSampleGoals();
    }

    try {
      final response = await _api.get<Map<String, dynamic>>(
        '/households/$householdId/goals',
      );
      final payload = ApiResponseUtils.unwrapData(response.data);
      final rawList = ApiResponseUtils.unwrapCollection(payload);
      return rawList.map((item) => GoalModel.fromJson(item)).toList();
    } catch (_) {
      return _fallbackSampleGoals();
    }
  }

  Future<GoalModel?> createGoal({
    required int? householdId,
    required Map<String, dynamic> data,
  }) async {
    if (householdId == null || householdId <= 0) {
      final createdAt = DateTime.now();
      return GoalModel(
        id: createdAt.millisecondsSinceEpoch,
        name: (data['name'] ?? 'Goal').toString(),
        targetCents: _toInt(data['target_cents'] ?? data['targetCents'] ?? 0),
        currentCents: _toInt(data['current_cents'] ?? data['currentCents'] ?? 0),
        type: (data['type'] ?? 'savings').toString(),
        dueDate: DateTime.tryParse(data['due_date']?.toString() ?? '') ?? createdAt,
        notes: data['notes']?.toString(),
      );
    }

    try {
      final response = await _api.post<Map<String, dynamic>>(
        '/households/$householdId/goals',
        data: data,
      );
      final payload = ApiResponseUtils.unwrapRecord(response.data) ?? data;
      return GoalModel.fromJson(payload);
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

  List<GoalModel> _fallbackSampleGoals() {
    return [
      GoalModel(
        id: 1,
        name: 'Emergency fund',
        targetCents: 150000,
        currentCents: 98000,
        type: 'savings',
        dueDate: DateTime(2026, 12, 1),
      ),
      GoalModel(
        id: 2,
        name: 'Dream vacation',
        targetCents: 90000,
        currentCents: 42000,
        type: 'savings',
        dueDate: DateTime(2027, 6, 1),
      ),
      GoalModel(
        id: 3,
        name: 'Credit card payoff',
        targetCents: 35000,
        currentCents: 22000,
        type: 'debt',
        dueDate: DateTime(2027, 2, 1),
      ),
    ];
  }
}
