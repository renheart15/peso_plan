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
      monthlySpending: months.isNotEmpty ? months : _defaultMonthlySpend(),
      categoryBreakdown: categories.isNotEmpty ? categories : _defaultCategories(),
      netCashCents: _asInt(
        root['net_cash_cents'] ??
            root['netCashCents'] ??
            root['net_cents'] ??
            root['netCents'] ??
            42000,
      ),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static List<ReportBarModel> _defaultMonthlySpend() => const [
    ReportBarModel(label: 'Jan', valueCents: 18000),
    ReportBarModel(label: 'Feb', valueCents: 22000),
    ReportBarModel(label: 'Mar', valueCents: 19500),
    ReportBarModel(label: 'Apr', valueCents: 26000),
    ReportBarModel(label: 'May', valueCents: 24500),
    ReportBarModel(label: 'Jun', valueCents: 29000),
  ];

  static List<ReportCategoryModel> _defaultCategories() => const [
    ReportCategoryModel(label: 'Housing', valuePercent: 26, colorHex: '#1A6B4A'),
    ReportCategoryModel(label: 'Groceries', valuePercent: 22, colorHex: '#0E7C86'),
    ReportCategoryModel(label: 'Transport', valuePercent: 16, colorHex: '#3A86FF'),
    ReportCategoryModel(label: 'Utilities', valuePercent: 14, colorHex: '#B7791F'),
    ReportCategoryModel(label: 'Fun', valuePercent: 12, colorHex: '#8A5CF6'),
    ReportCategoryModel(label: 'Other', valuePercent: 10, colorHex: '#B53A2F'),
  ];
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
