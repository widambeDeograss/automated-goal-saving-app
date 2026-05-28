import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/wallet.dart';
import '../state/wallet_provider.dart';
import '../theme/tokens.dart';
import '../widgets/avatar_stack.dart';

class CreateConfirmScreen extends StatelessWidget {
  final WalletDraft draft;
  const CreateConfirmScreen({super.key, required this.draft});

  String _fmt(int n) => 'TZS ${n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

  String _unlockDate(int months) {
    final d = DateTime.now();
    return DateFormat('dd MMM yyyy').format(DateTime(d.year, d.month + months, d.day));
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
    final isGroup = draft.kind == WalletType.group;
    final accent = isGroup ? (isDark ? AppColors.purpleDark : AppColors.purple) : AppColors.blue;
    final accentLight = isGroup ? (isDark ? AppColors.purpleDarkBg : AppColors.purpleLight) : (isDark ? AppColors.blueDark : AppColors.blueLight);
    final memberCount = isGroup ? draft.members.length + 1 : 0;

    final rows = <List<String>>[
      ['Aina ya Akiba', isGroup ? '👥 Kikundi ($memberCount wanachama)' : '👤 Mtu Mmoja'],
      ['Jina la Mfuko', '${draft.emoji} ${draft.name}'],
      ['Lengo la Akiba', _fmt(draft.goal ?? 0)],
      ['Muda wa Kufunga', 'Miezi $lockM'],
      ['Tarehe ya Kufungua', _unlockDate(lockM)],
      if (isGroup) ['Mfumo wa Kutoa', '80% ya wanachama wakubali'],
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
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(padding: const EdgeInsets.all(4), child: Icon(Icons.arrow_back_ios_new_rounded, color: textSub, size: 20)),
                  ),
                  Text('Thibitisha Akiba', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text)),
                  const SizedBox(width: 28),
                ],
              ),
              const SizedBox(height: 16),

              // Icon + name
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(color: accentLight, borderRadius: BorderRadius.circular(20)),
                alignment: Alignment.center,
                child: Text(draft.emoji, style: const TextStyle(fontSize: 36)),
              ),
              const SizedBox(height: 12),
              Text(draft.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: text)),
              const SizedBox(height: 4),
              Text(
                isGroup ? 'Akiba ya Kikundi · $memberCount wanachama' : 'Akiba ya Mtu Mmoja',
                style: TextStyle(fontSize: 12, color: accent, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              // Members preview for groups
              if (isGroup && draft.members.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: shadow, blurRadius: 12, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      AvatarStack(
                        members: draft.members,
                        max: 5,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(fontSize: 12, color: textSub, height: 1.4),
                            children: [
                              const TextSpan(text: 'Wewe + '),
                              TextSpan(text: '${draft.members.length} wanachama', style: TextStyle(fontWeight: FontWeight.w700, color: text)),
                              const TextSpan(text: ' watapokea mwaliko'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

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
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        border: i < rows.length - 1 ? Border(bottom: BorderSide(color: border)) : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text(row[0], style: TextStyle(fontSize: 12, color: textSub))),
                          const SizedBox(width: 12),
                          Flexible(child: Text(row[1], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: text), textAlign: TextAlign.right)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: accentLight, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded, size: 16, color: accent),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isGroup
                            ? 'Mialiko itatumwa kwa wanachama ${draft.members.length}. Kutoa pesa baadaye kunahitaji uthibitisho wa 80% ya wanachama wote.'
                            : 'Mfuko huu utaanza kutunza pesa baada ya kuthibitisha. Unaweza kubadilisha lengo au kiwango wakati wowote.',
                        style: TextStyle(fontSize: 12, color: accent, height: 1.5),
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
                    final provider = context.read<WalletProvider>();
                    provider.addWallet(draft);
                    if (isGroup) {
                      Navigator.of(context).popUntil((r) => r.isFirst);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('✅ Kikundi kimeundwa! Mialiko ${draft.members.length} imetumwa.'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                        ),
                      );
                    } else {
                      final wallets = provider.wallets;
                      final newId = wallets.last.id;
                      Navigator.of(context).pushNamedAndRemoveUntil('/spend-prompt', (r) => r.isFirst, arguments: newId);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 4,
                    shadowColor: accent.withAlpha(85),
                  ),
                  child: Text(
                    isGroup ? 'Unda Kikundi na Tuma Mialiko' : 'Thibitisha Akiba',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
