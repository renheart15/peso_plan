import 'package:flutter/material.dart';

class AccountModel {
  const AccountModel({
    required this.id,
    required this.name,
    required this.balanceCents,
    required this.type,
    this.colorHex,
    this.lastUpdated,
  });

  final int id;
  final String name;
  final int balanceCents;
  final String type;
  final String? colorHex;
  final DateTime? lastUpdated;

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    final rawBalance =
        json['balance'] ??
        json['balance_cents'] ??
        json['current_balance'] ??
        json['balanceCents'] ??
        0;
    final parsedBalance = switch (rawBalance) {
      int value => value,
      double value => value.round(),
      String value => int.tryParse(value) ?? 0,
      _ => 0,
    };

    final type = (json['type'] ?? json['account_type'] ?? 'checking')
        .toString();
    final updatedAt = json['updated_at'] != null
        ? DateTime.tryParse(json['updated_at'].toString())
        : null;

    return AccountModel(
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? 'Account').toString(),
      balanceCents: parsedBalance,
      type: type,
      colorHex: json['color_hex'] as String? ?? json['colorHex'] as String?,
      lastUpdated: updatedAt,
    );
  }

  String get alias => type.replaceAll('_', ' ');

  Color get accentColor {
    if (colorHex != null && colorHex!.isNotEmpty) {
      try {
        return Color(
          int.parse(colorHex!.replaceFirst('#', ''), radix: 16) | 0xFF000000,
        );
      } catch (_) {
        // Fall back below.
      }
    }

    switch (type) {
      case 'savings':
        return const Color(0xFF0E7C86);
      case 'cash':
        return const Color(0xFFB7791F);
      case 'credit_card':
        return const Color(0xFFB53A2F);
      default:
        return const Color(0xFF1A6B4A);
    }
  }

  IconData get icon {
    switch (type) {
      case 'credit_card':
        return Icons.credit_card;
      case 'cash':
        return Icons.wallet;
      case 'savings':
        return Icons.savings;
      default:
        return Icons.account_balance_wallet;
    }
  }
}
