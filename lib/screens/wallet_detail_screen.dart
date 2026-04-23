import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/wallet.dart';
import '../models/transaction.dart';
import '../state/wallet_provider.dart';
import '../theme/tokens.dart';
import '../widgets/bottom_nav.dart';

class WalletDetailScreen extends StatelessWidget {
  final int walletId;
  const WalletDetailScreen({super.key, required this.walletId});

  String _fmt(int n) => 'TZS ${n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (context, provider, _) {
        final wallet = provider.getWallet(walletId);
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
        final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
        final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
        final text = isDark ? AppColors.darkText : AppColors.lightText;
        final textSub = isDark ? AppColors.darkTextSub : AppColors.lightTextSub;
        final shadow = isDark ? const Color(0x66000000) : const Color(0x14000000);
        final pct = wallet.progressPercent;
        final done = wallet.isGoalReached;
        final headerColor = done ? AppColors.success : wallet.color;

        return Scaffold(
          backgroundColor: bg,
          body: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _Header(wallet: wallet, headerColor: headerColor, pct: pct, done: done),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          // Balance card
                          Container(
                            margin: const EdgeInsets.fromLTRB(16, -20, 16, 0),
                            padding: const EdgeInsets.all(16),
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
                                    Text('SALIO LA SASA', style: TextStyle(fontSize: 11, color: textSub, letterSpacing: 0.5)),
                                    const SizedBox(height: 2),
                                    Text(_fmt(wallet.balance), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: text)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('LENGO', style: TextStyle(fontSize: 11, color: textSub, letterSpacing: 0.5)),
                                    const SizedBox(height: 2),
                                    Text(_fmt(wallet.goal), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: done ? AppColors.success : wallet.color)),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Remaining / goal reached banner
                          if (!done)
                            Container(
                              margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(color: AppColors.orangeLight, borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Kinachobaki hadi lengo', style: const TextStyle(fontSize: 12, color: AppColors.orange)),
                                  Text(_fmt(wallet.goal - wallet.balance), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.orange)),
                                ],
                              ),
                            )
                          else
                            Container(
                              margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('🎉 Hongera! Lengo limefikiwa!', style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600)),
                                  GestureDetector(
                                    onTap: () => Navigator.of(context).pushNamed('/goal-reached', arguments: walletId),
                                    child: const Text('Tazama →', style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w700)),
                                  ),
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
                                    onPressed: () => Navigator.of(context).pushNamed('/fund', arguments: walletId),
                                    icon: const Icon(Icons.arrow_downward_rounded, size: 16),
                                    label: const Text('Weka Pesa', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: wallet.color,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      elevation: 0,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: wallet.isLocked ? null : () => Navigator.of(context).pushNamed('/withdraw', arguments: walletId),
                                    icon: Icon(wallet.isLocked ? Icons.lock_outline_rounded : Icons.arrow_upward_rounded, size: 16),
                                    label: const Text('Toa Pesa', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: surface,
                                      foregroundColor: wallet.isLocked ? textSub : text,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: border, width: 1.5)),
                                      elevation: 0,
                                      disabledBackgroundColor: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt,
                                      disabledForegroundColor: textSub,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Lock notice
                          if (wallet.isLocked)
                            Container(
                              margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time_rounded, size: 15, color: AppColors.blue),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Imefungwa • Miezi ${wallet.monthsRemaining} iliyobaki', style: const TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w600)),
                                      Text('Unaweza kutoa tangu ${_fmtDate(wallet.unlockDate)}', style: const TextStyle(fontSize: 11, color: AppColors.blue)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          // Transactions header
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Historia ya Miamala', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: text)),
                                Text('${wallet.transactions.length} miamala', style: TextStyle(fontSize: 11, color: textSub)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (ctx, i) {
                          final tx = wallet.transactions[i];
                          final isIn = tx.type == TransactionType.deposit;
                          final txColor = isIn ? AppColors.success : AppColors.danger;
                          final txBg = isIn ? AppColors.successLight : AppColors.dangerLight;
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
                                Container(
                                  width: 36, height: 36,
                                  decoration: BoxDecoration(color: txBg, shape: BoxShape.circle),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    isIn ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                    size: 16, color: txColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(tx.note, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: text)),
                                      const SizedBox(height: 2),
                                      Text(tx.date, style: TextStyle(fontSize: 11, color: textSub)),
                                    ],
                                  ),
                                ),
                                Text('${isIn ? '+' : '-'}${_fmt(tx.amount)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: txColor)),
                              ],
                            ),
                          );
                        },
                        childCount: wallet.transactions.length,
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  ],
                ),
              ),
              BottomNav(active: NavTab.savings, onTap: (_) {}),
            ],
          ),
        );
      },
    );
  }

  String _fmtDate(DateTime d) {
    const months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Ago','Sep','Okt','Nov','Des'];
    return '${d.day.toString().padLeft(2,'0')} ${months[d.month-1]} ${d.year}';
  }
}

class _Header extends StatelessWidget {
  final Wallet wallet;
  final Color headerColor;
  final double pct;
  final bool done;

  const _Header({required this.wallet, required this.headerColor, required this.pct, required this.done});

  @override
  Widget build(BuildContext context) {
    final r = 60.0;
    final stroke = 8.0;
    final circ = 2 * pi * r;
    final progress = pct.clamp(0.0, 1.0);

    return Container(
      color: headerColor,
      padding: const EdgeInsets.fromLTRB(16, 52, 16, 32),
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
                  alignment: Alignment.center,
                  child: const Icon(Icons.chevron_left, color: Colors.white, size: 20),
                ),
              ),
              Text(wallet.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/edit', arguments: wallet.id),
                child: Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const Icon(Icons.edit_outlined, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 144, height: 144,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(144, 144),
                  painter: _HeaderRingPainter(progress: progress, stroke: stroke, r: r),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(wallet.emoji, style: const TextStyle(fontSize: 32)),
                    const SizedBox(height: 2),
                    Text('${(pct * 100).round()}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          const Text('ya lengo lako', style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

class _HeaderRingPainter extends CustomPainter {
  final double progress;
  final double stroke;
  final double r;
  _HeaderRingPainter({required this.progress, required this.stroke, required this.r});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final bgPaint = Paint()..color = Colors.white30..style = PaintingStyle.stroke..strokeWidth = stroke..strokeCap = StrokeCap.round;
    final fgPaint = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = stroke..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, r, bgPaint);
    if (progress > 0) {
      canvas.drawArc(Rect.fromCircle(center: center, radius: r), -pi / 2, 2 * pi * progress, false, fgPaint);
    }
  }

  @override
  bool shouldRepaint(_HeaderRingPainter old) => old.progress != progress;
}
