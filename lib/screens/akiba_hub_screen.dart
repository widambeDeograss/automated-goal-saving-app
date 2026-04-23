import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/wallet.dart';
import '../state/wallet_provider.dart';
import '../theme/tokens.dart';
import '../widgets/progress_ring.dart';
import '../widgets/bottom_nav.dart';

class AkibaHubScreen extends StatelessWidget {
  const AkibaHubScreen({super.key});

  String _fmt(int n) => 'TZS ${n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSub = isDark ? AppColors.darkTextSub : AppColors.lightTextSub;
    final shadow = isDark ? const Color(0x66000000) : const Color(0x14000000);

    return Consumer<WalletProvider>(
      builder: (context, provider, _) {
        final wallets = provider.wallets;
        final totalBalance = provider.totalBalance;
        final totalGoal = provider.totalGoal;
        final overallPct = provider.overallPercent;

        return Scaffold(
          backgroundColor: bg,
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Akiba ya Malengo', style: TextStyle(fontSize: 11, color: textSub, letterSpacing: 0.8)),
                              Text('Mifuko Yangu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: text)),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.notifications_none_rounded, color: textSub, size: 22),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),

                    // Summary Card
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: AppColors.blue.withAlpha(85), blurRadius: 20, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Jumla ya Akiba', style: const TextStyle(fontSize: 10, color: Colors.white70, letterSpacing: 0.8)),
                          const SizedBox(height: 4),
                          Text(_fmt(totalBalance), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)),
                          const SizedBox(height: 2),
                          Text('Lengo: ${_fmt(totalGoal)}', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: overallPct,
                              backgroundColor: Colors.white30,
                              valueColor: const AlwaysStoppedAnimation(Colors.white),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text('${(overallPct * 100).round()}% ya lengo lote',
                                style: const TextStyle(fontSize: 11, color: Colors.white70)),
                          ),
                        ],
                      ),
                    ),

                    // Wallets header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Mifuko (${wallets.length})', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: text)),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed('/create/step1'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                children: [
                                  const Icon(Icons.add, size: 14, color: AppColors.blue),
                                  const SizedBox(width: 4),
                                  Text('Unda Mpya', style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Wallet list
                    if (wallets.isEmpty) _EmptyState(onTap: () => Navigator.of(context).pushNamed('/create/step1')),
                    ...wallets.map((w) => _WalletCard(
                      wallet: w,
                      surface: surface,
                      border: border,
                      text: text,
                      textSub: textSub,
                      shadow: shadow,
                      fmt: _fmt,
                      onTap: () => Navigator.of(context).pushNamed('/detail', arguments: w.id),
                    )),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
              BottomNav(
                active: NavTab.savings,
                onTap: (_) {},
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WalletCard extends StatelessWidget {
  final Wallet wallet;
  final Color surface;
  final Color border;
  final Color text;
  final Color textSub;
  final Color shadow;
  final String Function(int) fmt;
  final VoidCallback onTap;

  const _WalletCard({
    required this.wallet,
    required this.surface,
    required this.border,
    required this.text,
    required this.textSub,
    required this.shadow,
    required this.fmt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pct = wallet.progressPercent;
    final done = wallet.isGoalReached;
    final ringColor = done ? AppColors.success : wallet.color;
    final badgeBg = done ? AppColors.success.withAlpha(30) : wallet.color.withAlpha(30);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: shadow, blurRadius: 12, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            ProgressRing(
              percent: pct,
              size: 60,
              strokeWidth: 5,
              color: ringColor,
              bgColor: border,
              child: Text(wallet.emoji, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(wallet.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: text), overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text('${fmt(wallet.balance)} / ${fmt(wallet.goal)}', style: TextStyle(fontSize: 12, color: textSub)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor: border,
                      valueColor: AlwaysStoppedAnimation(ringColor),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(8)),
              child: Text(
                '${(pct * 100).round()}%',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: ringColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onTap;
  const _EmptyState({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSub = isDark ? AppColors.darkTextSub : AppColors.lightTextSub;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        children: [
          const Text('🎯', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text('Bado huna mifuko', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: text)),
          const SizedBox(height: 6),
          Text('Unda mfuko wako wa kwanza wa akiba leo!', style: TextStyle(fontSize: 13, color: textSub), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Unda Akiba', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
