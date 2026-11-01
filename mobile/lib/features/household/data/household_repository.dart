import '../../../core/api/api_client.dart';
import '../../../core/api/api_response_utils.dart';
import '../domain/household_summary_model.dart';

class HouseholdRepository {
  HouseholdRepository({required this._api});

  final ApiClient _api;

  Future<HouseholdSummaryModel> getHouseholdSummary({required int? householdId}) async {
    if (householdId == null || householdId <= 0) {
      return _fallbackSummary();
    }

    try {
      final response = await _api.get<Map<String, dynamic>>(
        '/households/$householdId/summary',
      );
      final payload = ApiResponseUtils.unwrapData(response.data);
      return HouseholdSummaryModel.fromJson(payload);
    } catch (_) {
      return _fallbackSummary();
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

  HouseholdSummaryModel _fallbackSummary() {
    return const HouseholdSummaryModel(
      sharedCashCents: 58500,
      members: [
        HouseholdMemberModel(
          name: 'Maria Santos',
          role: 'Owner',
          avatar: 'MS',
          colorHex: '#1A6B4A',
        ),
        HouseholdMemberModel(
          name: 'Lio Santos',
          role: 'Partner',
          avatar: 'LS',
          colorHex: '#0E7C86',
        ),
        HouseholdMemberModel(
          name: 'Ari Santos',
          role: 'Child',
          avatar: 'AS',
          colorHex: '#B7791F',
        ),
      ],
      activity: [
        HouseholdActivityModel(
          title: 'Budget updated',
          detail: 'Groceries budget increased by ₱1,000',
          timeLabel: '2h ago',
        ),
        HouseholdActivityModel(
          title: 'Transaction imported',
          detail: 'CSV import completed with 42 rows',
          timeLabel: 'Yesterday',
        ),
        HouseholdActivityModel(
          title: 'Goal reached',
          detail: 'Emergency fund reached 80% milestone',
          timeLabel: '3 days ago',
        ),
      ],
    );
  }
}
