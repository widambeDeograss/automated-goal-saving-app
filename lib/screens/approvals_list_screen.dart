import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/wallet_provider.dart';
import '../theme/tokens.dart';
import '../widgets/avatar.dart';

class ApprovalsListScreen extends StatelessWidget {
  const ApprovalsListScreen({super.key});

  String _fmt(int n) => 'TZS ${n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSub = isDark ? AppColors.darkTextSub : AppColors.lightTextSub;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final purple = isDark ? AppColors.purpleDark : AppColors.purple;
    final shadow = isDark ? const Color(0x66000000) : const Color(0x14000000);

    return Consumer<WalletProvider>(
      builder: (context, provider, _) {
        final pending = provider.pendingForMe();

        return Scaffold(
          backgroundColor: bg,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(padding: const EdgeInsets.all(4), child: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: textSub)),
                      ),
                      Text('Maombi Yanayosubiri', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text)),
                      const SizedBox(width: 28),
                    ],
                  ),
                ),
                Expanded(
                  child: pending.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle_outline_rounded, size: 48, color: textMuted),
                              const SizedBox(height: 12),
                              Text('Hakuna maombi', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: text)),
                              const SizedBox(height: 6),
                              Text('Wanachama wa kikundi wakipiga ombi, utaona hapa', style: TextStyle(fontSize: 12, color: textSub), textAlign: TextAlign.center),
                            ],
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            Text('Maombi yafuatayo yanahitaji uamuzi wako. Kila ombi linahitaji 80% ya wanachama ili kuidhinishwa.', style: TextStyle(fontSize: 13, color: textSub, height: 1.5)),
                            const SizedBox(height: 16),
                            ...pending.map((r) {
                              final wallet = provider.getWallet(r.walletId);
                              final c = r.consensus;
                              final requester = r.approvals.firstWhere((a) => a.memberId == r.requestedById);
                              return GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed('/approve', arguments: r.id),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: surface,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [BoxShadow(color: shadow, blurRadius: 12, offset: const Offset(0, 2))],
                                    border: Border.all(color: AppColors.orange.withAlpha(85)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Avatar(initials: requester.initials, color: requester.color, size: 36),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(r.requestedBy, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: text)),
                                                Text('${wallet.emoji} ${wallet.name}', style: TextStyle(fontSize: 11, color: textSub)),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(color: AppColors.orangeLight, borderRadius: BorderRadius.circular(8)),
                                            child: const Text('INASUBIRI', style: TextStyle(fontSize: 9, color: AppColors.orange, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(color: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt, borderRadius: BorderRadius.circular(10)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('KIASI', style: TextStyle(fontSize: 10, color: textSub, letterSpacing: 0.5)),
                                                Text(_fmt(r.amount), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: purple)),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Text('"${r.reason.length > 70 ? '${r.reason.substring(0, 70)}…' : r.reason}"', style: TextStyle(fontSize: 12, color: text, height: 1.5, fontStyle: FontStyle.italic)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${c.yes} / ${c.required} wameidhinisha', style: TextStyle(fontSize: 11, color: textSub)),
                                          Text('Bofya kupiga kura →', style: TextStyle(fontSize: 12, color: purple, fontWeight: FontWeight.w700)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
