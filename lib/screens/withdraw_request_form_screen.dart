import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/wallet_provider.dart';
import '../theme/tokens.dart';
import '../widgets/avatar.dart';

class WithdrawRequestFormScreen extends StatefulWidget {
  final int walletId;
  const WithdrawRequestFormScreen({super.key, required this.walletId});

  @override
  State<WithdrawRequestFormScreen> createState() => _WithdrawRequestFormScreenState();
}

class _WithdrawRequestFormScreenState extends State<WithdrawRequestFormScreen> {
  final _amountCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

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
        final wallet = provider.getWallet(widget.walletId);
        final num = int.tryParse(_amountCtrl.text) ?? 0;
        final reasonOk = _reasonCtrl.text.trim().length >= 10;
        final amountOk = num >= 1000 && num <= wallet.balance;
        final overLimit = num > wallet.balance;
        final valid = amountOk && reasonOk;
        final activeMembers = wallet.activeMembers;
        final requiredApprovals = (activeMembers.length * 0.8).ceil();

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
                      Text('Ombi la Kutoa Pesa', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text)),
                      const SizedBox(width: 28),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // Group context
                      Container(
                        padding: const EdgeInsets.all(14),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            Text(wallet.emoji, style: const TextStyle(fontSize: 30)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('AKIBA YA KIKUNDI', style: TextStyle(fontSize: 10, color: Colors.white70, letterSpacing: 0.5)),
                                  Text(wallet.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                                  Text('Salio: ${_fmt(wallet.balance)}', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Amount
                      const _Label('KIASI (TZS)'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _amountCtrl,
                        onChanged: (_) => setState(() {}),
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: text, fontSize: 16, fontWeight: FontWeight.w700),
                        decoration: InputDecoration(
                          hintText: '0',
                          hintStyle: TextStyle(color: textMuted),
                          filled: true,
                          fillColor: surface,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: border, width: 1.5)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: overLimit ? AppColors.danger : amountOk ? AppColors.success : border, width: 1.5)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: overLimit ? AppColors.danger : amountOk ? AppColors.success : purple, width: 1.5)),
                        ),
                      ),
                      if (overLimit) Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: const Text('Kiasi kinazidi salio la kikundi', style: TextStyle(fontSize: 11, color: AppColors.danger)),
                      ),
                      const SizedBox(height: 14),

                      // Reason
                      _Label('SABABU (Wanachama watajua)'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _reasonCtrl,
                        onChanged: (_) => setState(() {}),
                        maxLines: 3,
                        style: TextStyle(color: text, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Eleza kwa nini unahitaji kutoa pesa hizi...',
                          hintStyle: TextStyle(color: textMuted, fontSize: 13),
                          filled: true,
                          fillColor: surface,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: border, width: 1.5)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: reasonOk ? AppColors.success : border, width: 1.5)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: reasonOk ? AppColors.success : purple, width: 1.5)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text('${_reasonCtrl.text.length} / 10+ herufi', style: TextStyle(fontSize: 10, color: reasonOk ? AppColors.success : textMuted)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Consensus info
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppColors.orangeLight, borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.group_outlined, size: 16, color: AppColors.orange),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  style: const TextStyle(fontSize: 12, color: AppColors.orange, height: 1.6),
                                  children: [
                                    const TextSpan(text: 'Ombi lako litatumwa kwa wanachama wote '),
                                    TextSpan(text: '${activeMembers.length}', style: const TextStyle(fontWeight: FontWeight.w700)),
                                    const TextSpan(text: '. Linahitaji kuidhinishwa na '),
                                    TextSpan(text: '$requiredApprovals kati ya ${activeMembers.length}', style: const TextStyle(fontWeight: FontWeight.w700)),
                                    const TextSpan(text: ' (80%) ili kuendelea.'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // My auto-approval
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: shadow, blurRadius: 8, offset: const Offset(0, 1))]),
                        child: Row(
                          children: [
                            Avatar(initials: 'M', color: purple, size: 30),
                            const SizedBox(width: 10),
                            Expanded(child: Text.rich(TextSpan(style: TextStyle(fontSize: 12, color: text), children: [const TextSpan(text: 'Unaomba kama '), TextSpan(text: 'Mimi', style: const TextStyle(fontWeight: FontWeight.w700))]))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(8)),
                              child: const Text('Imekubaliwa kiotomatiki', style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: valid
                          ? () {
                              provider.submitWithdrawRequest(widget.walletId, num, _reasonCtrl.text.trim());
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('✅ Ombi limetumwa kwa wanachama!'), backgroundColor: AppColors.success),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: valid ? purple : const Color(0xFFCCCCCC),
                        disabledBackgroundColor: const Color(0xFFCCCCCC),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: valid ? 4 : 0,
                        shadowColor: purple.withAlpha(85),
                      ),
                      child: const Text('Tuma Ombi kwa Wanachama', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
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

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.darkTextSub : AppColors.lightTextSub;
    return Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.5));
  }
}
