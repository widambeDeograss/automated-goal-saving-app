import 'package:flutter/material.dart';
import 'transaction.dart';

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
  });

  double get progressPercent => (balance / goal).clamp(0.0, 1.0);
  bool get isGoalReached => balance >= goal;

  DateTime get unlockDate {
    final d = DateTime(createdAt.year, createdAt.month + lockMonths, createdAt.day);
    return d;
  }

  bool get isLocked => DateTime.now().isBefore(unlockDate);

  int get monthsRemaining {
    final diff = unlockDate.difference(DateTime.now());
    return diff.isNegative ? 0 : (diff.inDays / 30).ceil();
  }

  Wallet copyWith({
    String? name,
    String? emoji,
    int? goal,
    int? balance,
    Color? color,
    int? lockMonths,
    List<WalletTransaction>? transactions,
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
    );
  }
}

class WalletDraft {
  String name;
  String emoji;
  int? goal;
  int autoSavePct;
  int lockMonths;

  WalletDraft({
    this.name = '',
    this.emoji = '🎯',
    this.goal,
    this.autoSavePct = 5,
    this.lockMonths = 3,
  });
}
