import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/wallet.dart';
import '../state/wallet_provider.dart';
import '../theme/tokens.dart';

class CreateConfirmScreen extends StatelessWidget {
  final WalletDraft draft;
  const CreateConfirmScreen({super.key, required this.draft});

  String _fmt(int n) => 'TZS ${n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

  String _unlockDate(int months) {
    final d = DateTime.now();
    return DateFormat('dd/MM/yyyy').format(DateTime(d.year, d.month + months, d.day));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSub = isDark ? AppColors.darkTextSub : AppColors.lightTextSub;
    final shadow = isDark ? const Color(0x66000000) : const Color(0x14000000);
    final lockM = draft.lockMonths;

    final rows = [
      ['Jina la Mfuko', '${draft.emoji} ${draft.name}'],
      ['Lengo la Akiba', _fmt(draft.goal ?? 0)],
      ['Kiwango Kiotomatiki', '${draft.autoSavePct}% ya pesa zinazoingia'],
      ['Muda wa Kufunga', 'Miezi $lockM'],
      ['Tarehe ya Kufungua', _unlockDate(lockM)],
      ['Akaunti', 'NMB, 2120050000223'],
      ['Tarehe ya Kuanza', DateFormat('dd/MM/yyyy').format(DateTime.now())],
    ];

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: Icon(Icons.chevron_left, color: textSub, size: 24), onPressed: () => Navigator.pop(context)),
                  Text('Thibitisha Akiba', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text)),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 16),

              // Icon + name
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(20)),
                alignment: Alignment.center,
                child: Text(draft.emoji, style: const TextStyle(fontSize: 36)),
              ),
              const SizedBox(height: 12),
              Text(draft.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: text)),
              const SizedBox(height: 4),
              Text('Akiba ya Malengo', style: TextStyle(fontSize: 13, color: textSub)),
              const SizedBox(height: 24),

              // Detail rows
              Container(
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: shadow, blurRadius: 12, offset: const Offset(0, 2))],
                ),
                child: Column(
                  children: rows.asMap().entries.map((e) {
                    final i = e.key;
                    final row = e.value;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                      decoration: BoxDecoration(
                        border: i < rows.length - 1 ? Border(bottom: BorderSide(color: border)) : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(row[0], style: TextStyle(fontSize: 12, color: textSub)),
                          Text(row[1], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: text)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.orangeLight, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.orange),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Mfuko huu utaanza kutunza pesa baada ya kuthibitisha. Unaweza kubadilisha lengo au kiwango wakati wowote.',
                        style: TextStyle(fontSize: 12, color: AppColors.orange, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<WalletProvider>().addWallet(draft);
                    // Pop all create screens, then navigate to hub
                    Navigator.of(context).popUntil((r) => r.isFirst);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Mfuko umeundwa!'),
                        backgroundColor: Color(0xFF22C55E),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                    shadowColor: AppColors.blue.withAlpha(85),
                  ),
                  child: const Text('Thibitisha Akiba', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
