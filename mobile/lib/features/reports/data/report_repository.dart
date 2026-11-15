import '../../../core/api/api_client.dart';
import '../../../core/api/api_response_utils.dart';
import '../domain/report_summary_model.dart';

class ReportRepository {
  ReportRepository({required this._api});

  final ApiClient _api;

  Future<ReportSummaryModel> getReportSummary({required int? householdId}) async {
    if (householdId == null || householdId <= 0) {
      throw StateError('A household is required to load reports.');
    }

    try {
      final response = await _api.get<Map<String, dynamic>>(
        '/households/$householdId/reports/summary',
      );
      final payload = ApiResponseUtils.unwrapData(response.data);
      return ReportSummaryModel.fromJson(payload);
    } catch (_) {
      rethrow;
    }
  }
}
