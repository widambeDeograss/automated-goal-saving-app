import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/wallet_provider.dart';
import '../models/group_models.dart';
import '../theme/tokens.dart';
import '../widgets/avatar.dart';

const _meId = 1;

class ApproveRequestScreen extends StatelessWidget {
  final int requestId;
  const ApproveRequestScreen({super.key, required this.requestId});

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
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final purple = isDark ? AppColors.purpleDark : AppColors.purple;
    final purpleLight = isDark ? AppColors.purpleDarkBg : AppColors.purpleLight;
    final shadow = isDark ? const Color(0x66000000) : const Color(0x14000000);

    return Consumer<WalletProvider>(
      builder: (context, provider, _) {
        final request = provider.requests.firstWhere((r) => r.id == requestId);
        final wallet = provider.getWallet(request.walletId);
        final c = request.consensus;
        final myEntry = request.approvals.firstWhere((a) => a.memberId == _meId);
        final myVote = myEntry.vote;
        final isMyRequest = request.requestedById == _meId;
        final requester = request.approvals.firstWhere((a) => a.memberId == request.requestedById);

        final Color statusColor = c.passed ? AppColors.success : c.failed ? AppColors.danger : purple;
        final String statusLabel = c.passed ? 'IMEIDHINISHWA' : c.failed ? 'IMEKATALIWA' : 'INASUBIRI';

        return Scaffold(
          backgroundColor: bg,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(padding: const EdgeInsets.all(4), child: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: textSub)),
                      ),
                      Text('Ombi la Kutoa Pesa', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text)),
                      const SizedBox(width: 28),
                    ],
                  ),
                ),

                // Status pill
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(color: statusColor.withAlpha(34), borderRadius: BorderRadius.circular(14)),
                    child: Text(statusLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: statusColor, letterSpacing: 1)),
                  ),
                ),
                const SizedBox(height: 16),

                // Requester card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: shadow, blurRadius: 12, offset: const Offset(0, 2))]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Avatar(initials: requester.initials, color: requester.color, size: 48, fontSize: 18),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Aliyeomba', style: TextStyle(fontSize: 11, color: textSub)),
                                Text('${request.requestedBy}${isMyRequest ? ' (wewe)' : ''}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: text)),
                                Text(request.requestedAt, style: TextStyle(fontSize: 11, color: textMuted)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(color: border, height: 28),
                      Text('ANAOMBA KUTOA', style: TextStyle(fontSize: 10, color: textSub, letterSpacing: 0.5)),
                      const SizedBox(height: 4),
                      Text(_fmt(request.amount), style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: purple, height: 1.1)),
                      const SizedBox(height: 6),
                      Text('kutoka ${wallet.emoji} ${wallet.name} · Salio: ${_fmt(wallet.balance)}', style: TextStyle(fontSize: 11, color: textSub)),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: surfaceAlt, borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('SABABU', style: TextStyle(fontSize: 10, color: textSub, letterSpacing: 0.5)),
                            const SizedBox(height: 4),
                            Text('"${request.reason}"', style: TextStyle(fontSize: 13, color: text, height: 1.6, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Consensus tracker
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: shadow, blurRadius: 12, offset: const Offset(0, 2))]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Uthibitisho wa Wanachama', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: text)),
                          Text('${c.yes} / ${c.required}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: statusColor)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: c.pct,
                          backgroundColor: border,
                          valueColor: AlwaysStoppedAnimation(statusColor),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Inahitaji ${c.required} kati ya ${c.total} wanachama (80%)', style: TextStyle(fontSize: 11, color: textSub)),
                      const SizedBox(height: 14),
                      ...request.approvals.map((a) {
                        final vColor = a.vote == VoteChoice.yes ? AppColors.success : a.vote == VoteChoice.no ? AppColors.danger : textMuted;
                        final vLabel = a.vote == VoteChoice.yes ? 'Amekubali' : a.vote == VoteChoice.no ? 'Amekataa' : 'Anasubiri';
                        final vIcon = a.vote == VoteChoice.yes ? Icons.check_rounded : a.vote == VoteChoice.no ? Icons.close_rounded : Icons.access_time_rounded;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(color: surfaceAlt, borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Avatar(initials: a.initials, color: a.color, size: 28, fontSize: 11),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${a.name}${a.memberId == _meId ? ' (wewe)' : ''}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: text)),
                                    if (a.memberId == request.requestedById)
                                      Text('MUOMBAJI', style: TextStyle(fontSize: 9, color: purple, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(vIcon, size: 12, color: vColor),
                                  const SizedBox(width: 4),
                                  Text(vLabel, style: TextStyle(fontSize: 11, color: vColor, fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Vote buttons
                if (request.status == 'pending' && !isMyRequest && myVote == null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            provider.voteOnRequest(requestId, VoteChoice.no);
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Umekataa ombi hili'), backgroundColor: AppColors.danger),
                            );
                          },
                          icon: const Icon(Icons.close_rounded, size: 16),
                          label: const Text('Kataa', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.danger,
                            side: const BorderSide(color: AppColors.danger, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            provider.voteOnRequest(requestId, VoteChoice.yes);
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('✅ Umekubali ombi!'), backgroundColor: AppColors.success),
                            );
                          },
                          icon: const Icon(Icons.check_rounded, size: 16),
                          label: const Text('Kubali Ombi', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 4,
                            shadowColor: AppColors.success.withAlpha(85),
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else if (myVote != null && !isMyRequest) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: myVote == VoteChoice.yes ? AppColors.successLight : AppColors.dangerLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '✓ Umepiga kura yako: ${myVote == VoteChoice.yes ? 'Umekubali' : 'Umekataa'}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: myVote == VoteChoice.yes ? AppColors.success : AppColors.danger),
                    ),
                  ),
                ] else if (isMyRequest && request.status == 'pending') ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: purpleLight, borderRadius: BorderRadius.circular(12)),
                    child: Text('⏳ Ombi lako linasubiri uthibitisho wa wanachama wengine', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: purple)),
                  ),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
