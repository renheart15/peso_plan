import 'package:flutter/material.dart';

class BudgetCategoryModel {
  const BudgetCategoryModel({
    required this.id,
    required this.name,
    required this.plannedCents,
    required this.spentCents,
    this.iconName,
    this.colorHex,
  });

  final int id;
  final String name;
  final int plannedCents;
  final int spentCents;
  final String? iconName;
  final String? colorHex;

  factory BudgetCategoryModel.fromJson(Map<String, dynamic> json) {
    final planned = _asInt(json['planned_cents'] ?? json['plannedCents'] ?? json['budgeted_cents'] ?? 0);
    final spent = _asInt(json['spent_cents'] ?? json['spentCents'] ?? json['actual_cents'] ?? 0);

    return BudgetCategoryModel(
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? json['category_name'] ?? 'Category').toString(),
      plannedCents: planned,
      spentCents: spent,
      iconName: json['icon']?.toString() ?? json['icon_name']?.toString(),
      colorHex: json['color_hex']?.toString() ?? json['colorHex']?.toString(),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  bool get isOverBudget => spentCents > plannedCents;

  IconData get icon {
    switch ((iconName ?? name).toLowerCase()) {
      case 'housing':
      case 'home':
        return Icons.home_outlined;
      case 'groceries':
      case 'shopping':
        return Icons.shopping_basket_outlined;
      case 'transport':
      case 'car':
        return Icons.directions_car_outlined;
      case 'utilities':
      case 'electric':
        return Icons.electrical_services_outlined;
      case 'fun':
      case 'entertainment':
        return Icons.movie_outlined;
      case 'health':
      case 'medical':
        return Icons.medical_services_outlined;
      case 'travel':
        return Icons.flight_outlined;
      case 'food':
      case 'dining':
        return Icons.restaurant_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  Color get accentColor {
    if (colorHex != null && colorHex!.isNotEmpty) {
      try {
        return Color(
          int.parse(colorHex!.replaceFirst('#', ''), radix: 16) | 0xFF000000,
        );
      } catch (_) {}
    }

    switch (name.toLowerCase()) {
      case 'housing':
        return const Color(0xFF1A6B4A);
      case 'groceries':
        return const Color(0xFF0E7C86);
      case 'transport':
        return const Color(0xFF3A86FF);
      case 'utilities':
        return const Color(0xFFB7791F);
      default:
        return const Color(0xFF8A5CF6);
    }
  }
}
