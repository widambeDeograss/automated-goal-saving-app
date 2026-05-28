import 'package:flutter/material.dart';
import 'transaction.dart';
import 'group_models.dart';

enum WalletType { personal, group }

class Wallet {
  final int id;
  final String name;
  final String emoji;
  final int goal;
  final int balance;
  final Color color;
  final int lockMonths;
  final DateTime createdAt;
  final List<WalletTransaction> transactions;
  final WalletType type;
  final List<GroupMember> members;
  final int autoSavePct;

  const Wallet({
    required this.id,
    required this.name,
    required this.emoji,
    required this.goal,
    required this.balance,
    required this.color,
    required this.lockMonths,
    required this.createdAt,
    required this.transactions,
    this.type = WalletType.personal,
    this.members = const [],
    this.autoSavePct = 0,
  });

  double get progressPercent => goal > 0 ? (balance / goal).clamp(0.0, 1.0) : 0;
  bool get isGoalReached => balance >= goal;
  bool get isGroup => type == WalletType.group;

  DateTime get unlockDate {
    return DateTime(createdAt.year, createdAt.month + lockMonths, createdAt.day);
  }

  bool get isLocked => DateTime.now().isBefore(unlockDate);

  int get monthsRemaining {
    final diff = unlockDate.difference(DateTime.now());
    return diff.isNegative ? 0 : (diff.inDays / 30).ceil();
  }

  List<GroupMember> get activeMembers => members.where((m) => m.status == MemberStatus.active).toList();

  Wallet copyWith({
    String? name,
    String? emoji,
    int? goal,
    int? balance,
    Color? color,
    int? lockMonths,
    List<WalletTransaction>? transactions,
    List<GroupMember>? members,
    int? autoSavePct,
  }) {
    return Wallet(
      id: id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      goal: goal ?? this.goal,
      balance: balance ?? this.balance,
      color: color ?? this.color,
      lockMonths: lockMonths ?? this.lockMonths,
      createdAt: createdAt,
      transactions: transactions ?? this.transactions,
      type: type,
      members: members ?? this.members,
      autoSavePct: autoSavePct ?? this.autoSavePct,
    );
  }
}

class WalletDraft {
  String name;
  String emoji;
  int? goal;
  int autoSavePct;
  int lockMonths;
  WalletType kind;
  List<GroupMember> members;

  WalletDraft({
    this.name = '',
    this.emoji = '🎯',
    this.goal,
    this.autoSavePct = 5,
    this.lockMonths = 3,
    this.kind = WalletType.personal,
    List<GroupMember>? members,
  }) : members = members ?? [];
}
