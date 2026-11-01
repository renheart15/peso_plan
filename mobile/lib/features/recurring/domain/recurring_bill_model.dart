import 'package:flutter/material.dart';

class RecurringBillModel {
  const RecurringBillModel({
    required this.id,
    required this.name,
    required this.amountCents,
    required this.nextDue,
    required this.frequency,
    required this.autoPay,
    this.categoryName,
    this.colorHex,
  });

  final int id;
  final String name;
  final int amountCents;
  final DateTime nextDue;
  final String frequency;
  final bool autoPay;
  final String? categoryName;
  final String? colorHex;

  factory RecurringBillModel.fromJson(Map<String, dynamic> json) {
    final amount = _asInt(
      json['amount_cents'] ?? json['amountCents'] ?? json['amount'] ?? 0,
    );

    return RecurringBillModel(
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? 'Recurring bill').toString(),
      amountCents: amount,
      nextDue: DateTime.tryParse(
            (json['next_due'] ?? json['nextDue'] ?? DateTime.now().toIso8601String())
                .toString(),
          ) ??
          DateTime.now(),
      frequency: (json['frequency'] ?? 'monthly').toString(),
      autoPay: json['auto_pay'] is bool ? json['auto_pay'] as bool : false,
      categoryName: json['category_name']?.toString() ?? json['category']?.toString(),
      colorHex: json['color_hex']?.toString() ?? json['colorHex']?.toString(),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Color get accentColor {
    if (colorHex != null && colorHex!.isNotEmpty) {
      try {
        return Color(
          int.parse(colorHex!.replaceFirst('#', ''), radix: 16) | 0xFF000000,
        );
      } catch (_) {}
    }

    return autoPay ? const Color(0xFF1A6B4A) : const Color(0xFFB7791F);
  }
}
