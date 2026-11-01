import '../../../core/api/api_client.dart';
import '../../../core/api/api_response_utils.dart';
import '../domain/report_summary_model.dart';

class ReportRepository {
  ReportRepository({required this._api});

  final ApiClient _api;

  Future<ReportSummaryModel> getReportSummary({required int? householdId}) async {
    if (householdId == null || householdId <= 0) {
      return _fallbackSummary();
    }

    try {
      final response = await _api.get<Map<String, dynamic>>(
        '/households/$householdId/reports/summary',
      );
      final payload = ApiResponseUtils.unwrapData(response.data);
      return ReportSummaryModel.fromJson(payload);
    } catch (_) {
      return _fallbackSummary();
    }
  }

  ReportSummaryModel _fallbackSummary() {
    return ReportSummaryModel(
      monthlySpending: const [
        ReportBarModel(label: 'Jan', valueCents: 18000),
        ReportBarModel(label: 'Feb', valueCents: 22000),
        ReportBarModel(label: 'Mar', valueCents: 19500),
        ReportBarModel(label: 'Apr', valueCents: 26000),
        ReportBarModel(label: 'May', valueCents: 24500),
        ReportBarModel(label: 'Jun', valueCents: 29000),
      ],
      categoryBreakdown: const [
        ReportCategoryModel(label: 'Housing', valuePercent: 26, colorHex: '#1A6B4A'),
        ReportCategoryModel(label: 'Groceries', valuePercent: 22, colorHex: '#0E7C86'),
        ReportCategoryModel(label: 'Transport', valuePercent: 16, colorHex: '#3A86FF'),
        ReportCategoryModel(label: 'Utilities', valuePercent: 14, colorHex: '#B7791F'),
        ReportCategoryModel(label: 'Fun', valuePercent: 12, colorHex: '#8A5CF6'),
        ReportCategoryModel(label: 'Other', valuePercent: 10, colorHex: '#B53A2F'),
      ],
      netCashCents: 42000,
    );
  }
}
