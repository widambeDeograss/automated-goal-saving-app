import 'package:flutter/material.dart';
import '../models/wallet.dart';
import '../models/transaction.dart';

class WalletProvider extends ChangeNotifier {
  List<Wallet> _wallets = [
    Wallet(
      id: 1,
      name: 'Likizo ya Zanzibar',
      emoji: '🏖',
      goal: 2000000,
      balance: 1340000,
      color: const Color(0xFF3AABDF),
      lockMonths: 3,
      createdAt: DateTime(2025, 12, 22),
      transactions: const [
        WalletTransaction(id: 1, type: TransactionType.deposit, amount: 500000, date: '20 Apr 2026', note: 'Akiba ya awali'),
        WalletTransaction(id: 2, type: TransactionType.deposit, amount: 340000, date: '15 Apr 2026', note: 'Mwisho wa mwezi'),
        WalletTransaction(id: 3, type: TransactionType.deposit, amount: 500000, date: '01 Apr 2026', note: 'Akiba ya awali'),
      ],
    ),
    Wallet(
      id: 2,
      name: 'Gari Mpya',
      emoji: '🚗',
      goal: 8000000,
      balance: 3200000,
      color: const Color(0xFFF6A800),
      lockMonths: 6,
      createdAt: DateTime(2026, 2, 22),
      transactions: const [
        WalletTransaction(id: 1, type: TransactionType.deposit, amount: 1000000, date: '18 Apr 2026', note: 'Malipo ya awali'),
        WalletTransaction(id: 2, type: TransactionType.deposit, amount: 2200000, date: '05 Apr 2026', note: 'Bonus ya kazi'),
      ],
    ),
    Wallet(
      id: 3,
      name: 'Dharura',
      emoji: '🛡',
      goal: 1000000,
      balance: 1000000,
      color: const Color(0xFF22C55E),
      lockMonths: 3,
      createdAt: DateTime(2025, 12, 22),
      transactions: const [
        WalletTransaction(id: 1, type: TransactionType.deposit, amount: 500000, date: '10 Apr 2026', note: 'Awali'),
        WalletTransaction(id: 2, type: TransactionType.deposit, amount: 500000, date: '22 Mar 2026', note: 'Nyongeza'),
      ],
    ),
  ];

  List<Wallet> get wallets => List.unmodifiable(_wallets);

  int get totalGoal => _wallets.fold(0, (s, w) => s + w.goal);
  int get totalBalance => _wallets.fold(0, (s, w) => s + w.balance);
  double get overallPercent => totalGoal > 0 ? (totalBalance / totalGoal).clamp(0.0, 1.0) : 0;

  void addWallet(WalletDraft draft) {
    final now = DateTime.now();
    final newWallet = Wallet(
      id: now.millisecondsSinceEpoch,
      name: draft.name,
      emoji: draft.emoji,
      goal: draft.goal ?? 0,
      balance: 0,
      color: const Color(0xFF3AABDF),
      lockMonths: draft.lockMonths,
      createdAt: now,
      transactions: const [],
    );
    _wallets = [..._wallets, newWallet];
    notifyListeners();
  }

  void fundWallet(int walletId, int amount) {
    _wallets = _wallets.map((w) {
      if (w.id != walletId) return w;
      final now = DateTime.now();
      final tx = WalletTransaction(
        id: now.millisecondsSinceEpoch,
        type: TransactionType.deposit,
        amount: amount,
        date: '${now.day} ${_monthName(now.month)} ${now.year}',
        note: 'Malipo ya mkono',
      );
      return w.copyWith(
        balance: w.balance + amount,
        transactions: [tx, ...w.transactions],
      );
    }).toList();
    notifyListeners();
  }

  void withdrawFunds(int walletId, int amount) {
    _wallets = _wallets.map((w) {
      if (w.id != walletId) return w;
      final now = DateTime.now();
      final tx = WalletTransaction(
        id: now.millisecondsSinceEpoch,
        type: TransactionType.withdrawal,
        amount: amount,
        date: '${now.day} ${_monthName(now.month)} ${now.year}',
        note: 'Kutoa mkono',
      );
      return w.copyWith(
        balance: w.balance - amount,
        transactions: [tx, ...w.transactions],
      );
    }).toList();
    notifyListeners();
  }

  void updateWallet(Wallet updated) {
    _wallets = _wallets.map((w) => w.id == updated.id ? updated : w).toList();
    notifyListeners();
  }

  Wallet getWallet(int id) => _wallets.firstWhere((w) => w.id == id);

  String _monthName(int m) {
    const names = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Ago','Sep','Okt','Nov','Des'];
    return names[m - 1];
  }
}
