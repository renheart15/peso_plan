import '../../../core/api/api_client.dart';
import '../../../core/api/api_response_utils.dart';
import '../domain/household_summary_model.dart';

class HouseholdRepository {
  HouseholdRepository({required this._api});

  final ApiClient _api;

  Future<HouseholdSummaryModel> getHouseholdSummary({required int? householdId}) async {
    if (householdId == null || householdId <= 0) {
      throw StateError('A household is required to load household details.');
    }

    try {
      final response = await _api.get<Map<String, dynamic>>(
        '/households/$householdId/summary',
      );
      final payload = ApiResponseUtils.unwrapData(response.data);
      return HouseholdSummaryModel.fromJson(payload);
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> inviteMember({
    required int? householdId,
    required String email,
    required String role,
  }) async {
    if (householdId == null || householdId <= 0) {
      return false;
    }

    try {
      await _api.post<Map<String, dynamic>>(
        '/households/$householdId/invite',
        data: {
          'email': email,
          'role': role,
        },
      );
      return true;
    } catch (_) {
      return false;
    }
  }

}
