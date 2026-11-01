import 'package:flutter/material.dart';

class GoalModel {
  const GoalModel({
    required this.id,
    required this.name,
    required this.targetCents,
    required this.currentCents,
    required this.type,
    this.dueDate,
    this.notes,
  });

  final int id;
  final String name;
  final int targetCents;
  final int currentCents;
  final String type;
  final DateTime? dueDate;
  final String? notes;

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    final target = _asInt(json['target_cents'] ?? json['targetCents'] ?? 0);
    final current = _asInt(json['current_cents'] ?? json['currentCents'] ?? 0);

    return GoalModel(
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? 'Goal').toString(),
      targetCents: target,
      currentCents: current,
      type: (json['type'] ?? 'savings').toString(),
      dueDate: json['due_date'] != null
          ? DateTime.tryParse(json['due_date'].toString())
          : null,
      notes: json['notes']?.toString(),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  bool get isDebtGoal => type == 'debt';

  Color get accentColor {
    return isDebtGoal ? const Color(0xFFB53A2F) : const Color(0xFF1A6B4A);
  }

  IconData get icon {
    return isDebtGoal ? Icons.payments_outlined : Icons.savings_outlined;
  }
}
