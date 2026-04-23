import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/wallet_provider.dart';
import '../theme/tokens.dart';

class WithdrawFundsScreen extends StatefulWidget {
  final int walletId;
  const WithdrawFundsScreen({super.key, required this.walletId});

  @override
  State<WithdrawFundsScreen> createState() => _WithdrawFundsScreenState();
}

class _WithdrawFundsScreenState extends State<WithdrawFundsScreen> {
  final _controller = TextEditingController();
  int? _amount;

  String _fmt(int n) => 'TZS ${n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

  String _fmtDate(DateTime d) {
    const months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Ago','Sep','Okt','Nov','Des'];
    return '${d.day.toString().padLeft(2,'0')} ${months[d.month-1]} ${d.year}';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WalletProvider>();
    final wallet = provider.getWallet(widget.walletId);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSub = isDark ? AppColors.darkTextSub : AppColors.lightTextSub;
    final shadow = isDark ? const Color(0x66000000) : const Color(0x14000000);
    final locked = wallet.isLocked;
    final num = _amount ?? 0;
    final overLimit = num > wallet.balance;
    final valid = !locked && num >= 1000 && !overLimit;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: Icon(Icons.chevron_left, color: textSub, size: 24), onPressed: () => Navigator.pop(context)),
                  Text('Toa Pesa', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text)),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 20),

              // Lock banner
              if (locked) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(color: AppColors.blue.withAlpha(34), shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: const Icon(Icons.lock_outline_rounded, size: 26, color: AppColors.blue),
                      ),
                      const SizedBox(height: 12),
                      Text('Mfuko Umefungwa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: text)),
                      const SizedBox(height: 6),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(fontSize: 13, color: textSub, height: 1.6),
                          children: [
                            const TextSpan(text: 'Mfuko huu utafunguliwa tarehe\n'),
                            TextSpan(
                              text: _fmtDate(wallet.unlockDate),
                              style: const TextStyle(color: AppColors.blue, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(10)),
                        child: Text('Miezi ${wallet.monthsRemaining} iliyobaki', style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Uliweka muda wa kufunga wa miezi ${wallet.lockMonths} unapounda mfuko huu ili kujilinda dhidi ya kutoa mapema.',
                        style: TextStyle(fontSize: 12, color: textSub, height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Balance info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: shadow, blurRadius: 12, offset: const Offset(0, 2))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(wallet.emoji, style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mfuko', style: TextStyle(fontSize: 11, color: textSub)),
                            Text(wallet.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: text)),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Salio', style: TextStyle(fontSize: 11, color: textSub)),
                        Text(_fmt(wallet.balance), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.success)),
                      ],
                    ),
                  ],
                ),
              ),

              if (!locked) ...[
                const SizedBox(height: 20),
                Text('Weka kiasi unachotaka kutoa', style: TextStyle(fontSize: 13, color: textSub)),
                const SizedBox(height: 8),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => setState(() => _amount = int.tryParse(v)),
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(color: textSub),
                    filled: true, fillColor: surface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: overLimit ? AppColors.danger : valid ? AppColors.success : border,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: overLimit ? AppColors.danger : AppColors.success, width: 1.5),
                    ),
                  ),
                  style: TextStyle(fontSize: 15, color: text),
                ),

                if (overLimit)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(color: AppColors.dangerLight, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.danger),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 12, color: AppColors.danger, height: 1.5),
                              children: [
                                const TextSpan(text: 'Kiasi kinachozidi salio yako ya '),
                                TextSpan(text: _fmt(wallet.balance), style: const TextStyle(fontWeight: FontWeight.bold)),
                                const TextSpan(text: '. Tafadhali weka kiasi kidogo zaidi.'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 12),
                // Quick % shortcuts
                Row(
                  children: [25, 50, 75, 100].map((p) {
                    final amt = (wallet.balance * p / 100).floor();
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() { _amount = amt; _controller.text = amt.toString(); }),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: surface,
                            border: Border.all(color: border),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('$p%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: text)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(12)),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline_rounded, size: 14, color: AppColors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text('Pesa zitatumwa kwa akaunti yako ya NMB, 2120050000223 ndani ya dakika 5.',
                            style: TextStyle(fontSize: 12, color: AppColors.blue, height: 1.5)),
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: locked
                      ? () => Navigator.pop(context)
                      : valid
                          ? () {
                              context.read<WalletProvider>().withdrawFunds(widget.walletId, _amount!);
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('✅ ${_fmt(_amount!)} imetolewa!'),
                                  backgroundColor: const Color(0xFF22C55E),
                                  behavior: SnackBarBehavior.floating,
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                ),
                              );
                            }
                          : null,
                  style: locked
                      ? ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: text,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: border, width: 1.5)),
                          elevation: 0,
                        )
                      : ElevatedButton.styleFrom(
                          backgroundColor: valid ? AppColors.success : Colors.grey[300],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                  child: Text(
                    locked ? 'Rudi' : valid ? 'Toa ${_fmt(_amount!)}' : 'Toa Pesa',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: locked ? text : null),
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
