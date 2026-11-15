import 'package:flutter/material.dart';

class ReportSummaryModel {
  const ReportSummaryModel({
    required this.monthlySpending,
    required this.categoryBreakdown,
    required this.netCashCents,
  });

  final List<ReportBarModel> monthlySpending;
  final List<ReportCategoryModel> categoryBreakdown;
  final int netCashCents;

  factory ReportSummaryModel.fromJson(Map<String, dynamic> json) {
    final root = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    final months = ((root['monthly_spending'] ?? root['monthlySpending']) as List? ?? const [])
        .map((item) => ReportBarModel.fromJson(item as Map<String, dynamic>))
        .toList();
    final categories = ((root['category_breakdown'] ?? root['categoryBreakdown']) as List? ?? const [])
        .map((item) => ReportCategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return ReportSummaryModel(
      monthlySpending: months,
      categoryBreakdown: categories,
      netCashCents: _asInt(
        root['net_cash_cents'] ??
            root['netCashCents'] ??
            root['net_cents'] ??
            root['netCents'] ??
            0,
      ),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

}

class ReportBarModel {
  const ReportBarModel({
    required this.label,
    required this.valueCents,
  });

  final String label;
  final int valueCents;

  factory ReportBarModel.fromJson(Map<String, dynamic> json) {
    return ReportBarModel(
      label: (json['label'] ?? json['month'] ?? 'Month').toString(),
      valueCents: _asInt(json['value_cents'] ?? json['valueCents'] ?? json['amount_cents'] ?? 0),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class ReportCategoryModel {
  const ReportCategoryModel({
    required this.label,
    required this.valuePercent,
    this.colorHex,
  });

  final String label;
  final int valuePercent;
  final String? colorHex;

  factory ReportCategoryModel.fromJson(Map<String, dynamic> json) {
    return ReportCategoryModel(
      label: (json['label'] ?? json['name'] ?? 'Category').toString(),
      valuePercent: _asInt(json['value_percent'] ?? json['valuePercent'] ?? json['percent'] ?? 0),
      colorHex: json['color_hex']?.toString() ?? json['colorHex']?.toString(),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Color get color {
    if (colorHex != null && colorHex!.isNotEmpty) {
      try {
        return Color(
          int.parse(colorHex!.replaceFirst('#', ''), radix: 16) | 0xFF000000,
        );
      } catch (_) {}
    }

    return const Color(0xFF1A6B4A);
  }
}
