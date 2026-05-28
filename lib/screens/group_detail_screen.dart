import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/wallet.dart';
import '../models/transaction.dart';
import '../models/group_models.dart';
import '../state/wallet_provider.dart';
import '../theme/tokens.dart';
import '../widgets/progress_ring.dart';
import '../widgets/avatar.dart';
import '../widgets/avatar_stack.dart';

class GroupDetailScreen extends StatefulWidget {
  final int walletId;
  const GroupDetailScreen({super.key, required this.walletId});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  bool _showMembers = false;

  String _fmt(int n) => 'TZS ${n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final surfaceAlt = isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSub = isDark ? AppColors.darkTextSub : AppColors.lightTextSub;
    final purple = isDark ? AppColors.purpleDark : AppColors.purple;
    final shadow = isDark ? const Color(0x66000000) : const Color(0x14000000);

    return Consumer<WalletProvider>(
      builder: (context, provider, _) {
        final wallet = provider.getWallet(widget.walletId);
        final pct = wallet.progressPercent;
        final done = wallet.isGoalReached;
        final headerColor = done ? AppColors.success : purple;
        final pendingReq = provider.pendingRequestForWallet(widget.walletId);
        final activeMembers = wallet.activeMembers;
        final pendingMembers = wallet.members.where((m) => m.status == MemberStatus.pending).toList();

        return Scaffold(
          backgroundColor: bg,
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Purple header
                    Container(
                      color: headerColor,
                      padding: const EdgeInsets.fromLTRB(16, 48, 16, 32),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  width: 32, height: 32,
                                  decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                                  child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.white),
                                ),
                              ),
                              Column(
                                children: [
                                  const Text('👥 Akiba ya Kikundi', style: TextStyle(fontSize: 9, color: Colors.white70, letterSpacing: 1, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 2),
                                  Text(wallet.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                                ],
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed('/edit', arguments: wallet.id),
                                child: Container(
                                  width: 32, height: 32,
                                  decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                                  child: const Icon(Icons.edit_outlined, size: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          ProgressRing(
                            percent: pct,
                            size: 140,
                            strokeWidth: 8,
                            color: Colors.white,
                            bgColor: Colors.white30,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(wallet.emoji, style: const TextStyle(fontSize: 30)),
                                Text('${(pct * 100).round()}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AvatarStack(members: activeMembers, max: 5, size: 22),
                              const SizedBox(width: 8),
                              Text('${activeMembers.length} wanachama hai', style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Balance card
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, -20, 16, 0),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: shadow, blurRadius: 12, offset: const Offset(0, 2))],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('SALIO LA KIKUNDI', style: TextStyle(fontSize: 10, color: textSub, letterSpacing: 0.5)),
                              const SizedBox(height: 2),
                              Text(_fmt(wallet.balance), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: text)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('LENGO', style: TextStyle(fontSize: 10, color: textSub, letterSpacing: 0.5)),
                              const SizedBox(height: 2),
                              Text(_fmt(wallet.goal), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: done ? AppColors.success : purple)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Pending request banner
                    if (pendingReq != null)
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed('/approve', arguments: pendingReq.id),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.orangeLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.orange.withAlpha(68)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time_rounded, size: 18, color: AppColors.orange),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Ombi la kutoa ${_fmt(pendingReq.amount)} linasubiri', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.orange)),
                                    Text('${pendingReq.consensus.yes} / ${pendingReq.consensus.required} wameidhinisha · Bofya tazama', style: TextStyle(fontSize: 10, color: textSub)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Lock notice
                    if (wallet.isLocked)
                      Container(
                        margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.blueDark : AppColors.blueLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.blue),
                            const SizedBox(width: 10),
                            Expanded(child: Text('Kufunguka ${_fmtDate(wallet.unlockDate)} · Miezi ${wallet.monthsRemaining} iliyobaki', style: const TextStyle(fontSize: 11, color: AppColors.blue))),
                          ],
                        ),
                      ),

                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.of(context).pushNamed('/fund', arguments: wallet.id),
                              icon: const Icon(Icons.arrow_downward_rounded, size: 16),
                              label: const Text('Weka Pesa', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: purple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                elevation: 4,
                                shadowColor: purple.withAlpha(85),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: (pendingReq != null || wallet.isLocked)
                                  ? null
                                  : () => Navigator.of(context).pushNamed('/group-withdraw', arguments: wallet.id),
                              icon: Icon(wallet.isLocked ? Icons.lock_outline_rounded : Icons.arrow_upward_rounded, size: 16),
                              label: const Text('Omba Kutoa', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: surface,
                                foregroundColor: text,
                                disabledBackgroundColor: surface,
                                disabledForegroundColor: textSub,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: border, width: 1.5)),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tabs
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: shadow, blurRadius: 12, offset: const Offset(0, 2))],
                      ),
                      child: Row(
                        children: [
                          _Tab(label: 'Miamala (${wallet.transactions.length})', selected: !_showMembers, accentColor: purple, onTap: () => setState(() => _showMembers = false)),
                          _Tab(label: 'Wanachama (${wallet.members.length})', selected: _showMembers, accentColor: purple, onTap: () => setState(() => _showMembers = true)),
                        ],
                      ),
                    ),

                    // Tab content
                    if (!_showMembers) ...[
                      ...wallet.transactions.map((tx) {
                        GroupMember? member;
                        if (tx.byId != null) {
                          final matches = wallet.members.where((m) => m.id == tx.byId);
                          if (matches.isNotEmpty) member = matches.first;
                        }
                        return Container(
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: shadow, blurRadius: 12, offset: const Offset(0, 2))],
                          ),
                          child: Row(
                            children: [
                              member != null
                                  ? Avatar(initials: member.initials, color: member.color, size: 36)
                                  : Container(
                                      width: 36, height: 36,
                                      decoration: BoxDecoration(
                                        color: tx.type == TransactionType.deposit ? AppColors.successLight : AppColors.dangerLight,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        tx.type == TransactionType.deposit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                        size: 16,
                                        color: tx.type == TransactionType.deposit ? AppColors.success : AppColors.danger,
                                      ),
                                    ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(tx.byName ?? tx.note, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: text)),
                                    Text('${tx.note} · ${tx.date}', style: TextStyle(fontSize: 11, color: textSub)),
                                  ],
                                ),
                              ),
                              Text(
                                '${tx.type == TransactionType.deposit ? '+' : '-'}${_fmt(tx.amount)}',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: tx.type == TransactionType.deposit ? AppColors.success : AppColors.danger),
                              ),
                            ],
                          ),
                        );
                      }),
                    ] else ...[
                      ...wallet.members.map((m) {
                        final totalContrib = wallet.transactions
                            .where((tx) => tx.byId == m.id && tx.type == TransactionType.deposit)
                            .fold(0, (s, tx) => s + tx.amount);
                        return Opacity(
                          opacity: m.isPending ? 0.65 : 1,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: surface,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: shadow, blurRadius: 12, offset: const Offset(0, 2))],
                            ),
                            child: Row(
                              children: [
                                Avatar(initials: m.initials, color: m.color, size: 40),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        spacing: 6,
                                        children: [
                                          Text(m.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: text)),
                                          if (m.isCreator) Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(color: isDark ? AppColors.purpleDarkBg : AppColors.purpleLight, borderRadius: BorderRadius.circular(6)),
                                            child: Text('MWANZILISHI', style: TextStyle(fontSize: 9, color: isDark ? AppColors.purpleDark : AppColors.purple, fontWeight: FontWeight.w700)),
                                          ),
                                          if (m.isPending) Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(color: AppColors.orangeLight, borderRadius: BorderRadius.circular(6)),
                                            child: const Text('INASUBIRI', style: TextStyle(fontSize: 9, color: AppColors.orange, fontWeight: FontWeight.w700)),
                                          ),
                                        ],
                                      ),
                                      Text(m.phone, style: TextStyle(fontSize: 11, color: textSub)),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('Mchango', style: TextStyle(fontSize: 10, color: textSub)),
                                    Text(_fmt(totalContrib), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.success)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      if (pendingMembers.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppColors.orangeLight, borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.orange),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text('Mwanachama ${pendingMembers.length} bado anasubiri kukubali mwaliko. Hawawezi kuweka pesa au kupiga kura mpaka wakubali.', style: const TextStyle(fontSize: 11, color: AppColors.orange, height: 1.5)),
                              ),
                            ],
                          ),
                        ),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _fmtDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ago', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool selected;
  final Color accentColor;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.selected, required this.accentColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: selected ? accentColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, fontWeight: selected ? FontWeight.w700 : FontWeight.w600, color: selected ? Colors.white : const Color(0xFF9CA3AF)),
          ),
        ),
      ),
    );
  }
}

