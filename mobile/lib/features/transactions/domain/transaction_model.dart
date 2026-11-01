import 'package:flutter/material.dart';

class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.amountCents,
    required this.date,
    required this.type,
    required this.accountName,
    this.accountId,
    this.notes,
  });

  final int id;
  final String title;
  final String category;
  final int amountCents;
  final DateTime date;
  final String type;
  final String accountName;
  final int? accountId;
  final String? notes;

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final amountValue = json['amount_cents'] ??
        json['amountCents'] ??
        json['amount'] ??
        json['total_cents'] ??
        0;
    final parsedAmount = switch (amountValue) {
      int value => value,
      double value => value.round(),
      String value => int.tryParse(value) ?? 0,
      _ => 0,
    };

    final rawType = (json['type'] ?? json['transaction_type'] ?? 'expense')
        .toString();
    final categoryValue = json['category'] is Map
        ? json['category']['name']
        : json['category_name'] ?? json['category'];
    final accountValue = json['account'] is Map
        ? json['account']['name']
        : json['account_name'] ?? json['account'];
    final dateValue = json['date'] ??
        json['posted_at'] ??
        json['transaction_date'] ??
        json['created_at'] ??
        DateTime.now().toIso8601String();

    final displayAmount = rawType == 'expense' && parsedAmount > 0
        ? -parsedAmount
        : parsedAmount;

    return TransactionModel(
      id: (json['id'] ?? 0) as int,
      title: (json['payee'] ??
              json['description'] ??
              json['title'] ??
              'Transaction').toString(),
      category: (categoryValue ?? 'General').toString(),
      amountCents: displayAmount,
      date: DateTime.tryParse(dateValue.toString()) ?? DateTime.now(),
      type: rawType,
      accountName: (accountValue ?? 'Account').toString(),
      accountId: json['account_id'] as int?,
      notes: json['notes']?.toString(),
    );
  }

  bool get isIncome => amountCents >= 0;

  Color get accentColor {
    return isIncome
        ? const Color(0xFF1A6B4A)
        : const Color(0xFFB53A2F);
  }

  IconData get icon {
    return isIncome ? Icons.arrow_downward : Icons.arrow_upward;
  }
}
