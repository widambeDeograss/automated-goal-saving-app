import 'package:flutter/material.dart';
import '../models/wallet.dart';
import '../models/transaction.dart';
import '../models/group_models.dart';

const _meId = 1;
const _meName = 'Mimi';
const _mePhone = '+255 754 100 100';
const _meInitials = 'M';

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
    Wallet(
      id: 4,
      type: WalletType.group,
      name: 'Familia ya Mwakasege',
      emoji: '👨‍👩‍👧‍👦',
      goal: 5000000,
      balance: 1800000,
      color: const Color(0xFF8B5CF6),
      lockMonths: 6,
      createdAt: DateTime(2026, 1, 22),
      members: const [
        GroupMember(id: 1, name: 'Mimi', phone: '+255 754 100 100', initials: 'M', role: MemberRole.creator, status: MemberStatus.active, color: Color(0xFF3AABDF), joinedAt: '2026-01-22'),
        GroupMember(id: 2, name: 'John Mwakasege', phone: '+255 754 200 200', initials: 'JM', role: MemberRole.member, status: MemberStatus.active, color: Color(0xFFF6A800), joinedAt: '2026-01-23'),
        GroupMember(id: 3, name: 'Asha Mussa', phone: '+255 754 300 300', initials: 'AM', role: MemberRole.member, status: MemberStatus.active, color: Color(0xFF22C55E), joinedAt: '2026-01-24'),
        GroupMember(id: 4, name: 'Peter Kimaro', phone: '+255 754 400 400', initials: 'PK', role: MemberRole.member, status: MemberStatus.active, color: Color(0xFFEF4444), joinedAt: '2026-01-25'),
        GroupMember(id: 5, name: 'Grace Ngowi', phone: '+255 754 500 500', initials: 'GN', role: MemberRole.member, status: MemberStatus.pending, color: Color(0xFF8B5CF6)),
      ],
      transactions: const [
        WalletTransaction(id: 1, type: TransactionType.deposit, amount: 400000, date: '22 Apr 2026', note: 'Mchango wa mwezi', byId: 1, byName: 'Mimi'),
        WalletTransaction(id: 2, type: TransactionType.deposit, amount: 500000, date: '18 Apr 2026', note: 'Mchango wa mwezi', byId: 2, byName: 'John Mwakasege'),
        WalletTransaction(id: 3, type: TransactionType.deposit, amount: 300000, date: '15 Apr 2026', note: 'Mchango wa awali', byId: 3, byName: 'Asha Mussa'),
        WalletTransaction(id: 4, type: TransactionType.deposit, amount: 400000, date: '12 Apr 2026', note: 'Mchango wa awali', byId: 4, byName: 'Peter Kimaro'),
        WalletTransaction(id: 5, type: TransactionType.deposit, amount: 200000, date: '05 Apr 2026', note: 'Mchango wa awali', byId: 2, byName: 'John Mwakasege'),
      ],
    ),
  ];

  List<GroupInvitation> _invitations = const [
    GroupInvitation(id: 1, fromName: 'John Mwakasege', fromPhone: '+255 754 200 200', fromInitials: 'JM', fromColor: Color(0xFFF6A800), groupName: 'Akiba ya Harusi', groupEmoji: '💍', goal: 8000000, memberCount: 4, lockMonths: 12, invitedAt: '20 Apr 2026'),
    GroupInvitation(id: 2, fromName: 'Grace Ngowi', fromPhone: '+255 754 500 500', fromInitials: 'GN', fromColor: Color(0xFF8B5CF6), groupName: 'Likizo ya Mama', groupEmoji: '🌍', goal: 3000000, memberCount: 3, lockMonths: 6, invitedAt: '22 Apr 2026'),
  ];

  List<WithdrawRequest> _requests = [
    WithdrawRequest(
      id: 1,
      walletId: 4,
      requestedById: 3,
      requestedBy: 'Asha Mussa',
      requestedAt: '21 Apr 2026',
      amount: 500000,
      reason: 'Matibabu ya dharura kwa mtoto wangu',
      status: 'pending',
      approvals: const [
        WithdrawApproval(memberId: 1, name: 'Mimi', initials: 'M', color: Color(0xFF3AABDF), vote: null),
        WithdrawApproval(memberId: 2, name: 'John Mwakasege', initials: 'JM', color: Color(0xFFF6A800), vote: VoteChoice.yes),
        WithdrawApproval(memberId: 3, name: 'Asha Mussa', initials: 'AM', color: Color(0xFF22C55E), vote: VoteChoice.yes),
        WithdrawApproval(memberId: 4, name: 'Peter Kimaro', initials: 'PK', color: Color(0xFFEF4444), vote: null),
        WithdrawApproval(memberId: 5, name: 'Grace Ngowi', initials: 'GN', color: Color(0xFF8B5CF6), vote: null),
      ],
    ),
  ];

  List<Wallet> get wallets => List.unmodifiable(_wallets);
  List<GroupInvitation> get invitations => List.unmodifiable(_invitations);
  List<WithdrawRequest> get requests => List.unmodifiable(_requests);

  int get totalGoal => _wallets.fold(0, (s, w) => s + w.goal);
  int get totalBalance => _wallets.fold(0, (s, w) => s + w.balance);
  double get overallPercent => totalGoal > 0 ? (totalBalance / totalGoal).clamp(0.0, 1.0) : 0;

  List<WithdrawRequest> pendingForMe() => _requests
      .where((r) => r.status == 'pending' && r.approvals.any((a) => a.memberId == _meId && a.vote == null))
      .toList();

  int get notificationCount => _invitations.length + pendingForMe().length;

  WithdrawRequest? pendingRequestForWallet(int walletId) {
    try {
      return _requests.firstWhere((r) => r.walletId == walletId && r.status == 'pending');
    } catch (_) {
      return null;
    }
  }

  void addWallet(WalletDraft draft) {
    final now = DateTime.now();
    final color = draft.kind == WalletType.group ? const Color(0xFF8B5CF6) : const Color(0xFF3AABDF);
    final newWallet = Wallet(
      id: now.millisecondsSinceEpoch,
      name: draft.name,
      emoji: draft.emoji,
      goal: draft.goal ?? 0,
      balance: 0,
      color: color,
      lockMonths: draft.lockMonths,
      createdAt: now,
      transactions: const [],
      type: draft.kind,
      autoSavePct: draft.kind == WalletType.personal ? draft.autoSavePct : 0,
      members: draft.kind == WalletType.group
          ? [
              const GroupMember(id: _meId, name: _meName, phone: _mePhone, initials: _meInitials, role: MemberRole.creator, status: MemberStatus.active, color: Color(0xFF3AABDF)),
              ...draft.members,
            ]
          : [],
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
        note: w.isGroup ? 'Mchango wa mkono' : 'Malipo ya mkono',
        byId: w.isGroup ? _meId : null,
        byName: w.isGroup ? _meName : null,
      );
      return w.copyWith(balance: w.balance + amount, transactions: [tx, ...w.transactions]);
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
      return w.copyWith(balance: w.balance - amount, transactions: [tx, ...w.transactions]);
    }).toList();
    notifyListeners();
  }

  void updateWallet(Wallet updated) {
    _wallets = _wallets.map((w) => w.id == updated.id ? updated : w).toList();
    notifyListeners();
  }

  Wallet getWallet(int id) => _wallets.firstWhere((w) => w.id == id);

  void acceptInvitation(int invitationId) {
    _invitations = _invitations.where((i) => i.id != invitationId).toList();
    notifyListeners();
  }

  void rejectInvitation(int invitationId) {
    _invitations = _invitations.where((i) => i.id != invitationId).toList();
    notifyListeners();
  }

  void submitWithdrawRequest(int walletId, int amount, String reason) {
    final wallet = getWallet(walletId);
    final now = DateTime.now();
    final approvals = wallet.activeMembers.map((m) => WithdrawApproval(
      memberId: m.id, name: m.name, initials: m.initials, color: m.color,
      vote: m.id == _meId ? VoteChoice.yes : null,
    )).toList();

    final req = WithdrawRequest(
      id: now.millisecondsSinceEpoch,
      walletId: walletId,
      requestedById: _meId,
      requestedBy: _meName,
      requestedAt: '${now.day} ${_monthName(now.month)} ${now.year}',
      amount: amount,
      reason: reason,
      status: 'pending',
      approvals: approvals,
    );
    _requests = [..._requests, req];
    notifyListeners();
  }

  void voteOnRequest(int requestId, VoteChoice vote) {
    _requests = _requests.map((r) {
      if (r.id != requestId) return r;
      final newApprovals = r.approvals.map((a) {
        if (a.memberId != _meId) return a;
        return a.withVote(vote);
      }).toList();
      final updated = r.copyWith(approvals: newApprovals);
      if (updated.consensus.passed) return updated.copyWith(status: 'approved');
      if (updated.consensus.failed) return updated.copyWith(status: 'rejected');
      return updated;
    }).toList();
    notifyListeners();
  }

  String _monthName(int m) {
    const names = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ago', 'Sep', 'Okt', 'Nov', 'Des'];
    return names[m - 1];
  }
}
