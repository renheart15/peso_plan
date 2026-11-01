import 'package:flutter/material.dart';

class HouseholdSummaryModel {
  const HouseholdSummaryModel({
    required this.sharedCashCents,
    required this.members,
    required this.activity,
  });

  final int sharedCashCents;
  final List<HouseholdMemberModel> members;
  final List<HouseholdActivityModel> activity;

  factory HouseholdSummaryModel.fromJson(Map<String, dynamic> json) {
    final root = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    final members = ((root['members']) as List? ?? const [])
        .map((item) => HouseholdMemberModel.fromJson(item as Map<String, dynamic>))
        .toList();
    final activity = ((root['activity']) as List? ?? const [])
        .map((item) => HouseholdActivityModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return HouseholdSummaryModel(
      sharedCashCents: _asInt(
        root['shared_cash_cents'] ??
            root['sharedCashCents'] ??
            58500,
      ),
      members: members.isNotEmpty ? members : _defaultMembers(),
      activity: activity.isNotEmpty ? activity : _defaultActivity(),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static List<HouseholdMemberModel> _defaultMembers() => const [
    HouseholdMemberModel(name: 'Maria Santos', role: 'Owner', avatar: 'MS', colorHex: '#1A6B4A'),
    HouseholdMemberModel(name: 'Lio Santos', role: 'Partner', avatar: 'LS', colorHex: '#0E7C86'),
    HouseholdMemberModel(name: 'Ari Santos', role: 'Child', avatar: 'AS', colorHex: '#B7791F'),
  ];

  static List<HouseholdActivityModel> _defaultActivity() => const [
    HouseholdActivityModel(title: 'Budget updated', detail: 'Groceries budget increased by ₱1,000', timeLabel: '2h ago'),
    HouseholdActivityModel(title: 'Transaction imported', detail: 'CSV import completed with 42 rows', timeLabel: 'Yesterday'),
    HouseholdActivityModel(title: 'Goal reached', detail: 'Emergency fund reached 80% milestone', timeLabel: '3 days ago'),
  ];
}

class HouseholdMemberModel {
  const HouseholdMemberModel({
    required this.name,
    required this.role,
    required this.avatar,
    this.colorHex,
  });

  final String name;
  final String role;
  final String avatar;
  final String? colorHex;

  factory HouseholdMemberModel.fromJson(Map<String, dynamic> json) {
    return HouseholdMemberModel(
      name: (json['name'] ?? 'Member').toString(),
      role: (json['role'] ?? 'Member').toString(),
      avatar: (json['avatar'] ?? _initials((json['name'] ?? 'Member').toString())).toString(),
      colorHex: json['color_hex']?.toString() ?? json['colorHex']?.toString(),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
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

class HouseholdActivityModel {
  const HouseholdActivityModel({
    required this.title,
    required this.detail,
    required this.timeLabel,
  });

  final String title;
  final String detail;
  final String timeLabel;

  factory HouseholdActivityModel.fromJson(Map<String, dynamic> json) {
    return HouseholdActivityModel(
      title: (json['title'] ?? 'Activity').toString(),
      detail: (json['detail'] ?? json['message'] ?? 'Recent household activity').toString(),
      timeLabel: (json['time_label'] ?? json['timeLabel'] ?? json['time'] ?? 'Now').toString(),
    );
  }
}
