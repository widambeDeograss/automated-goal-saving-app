import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/wallet_provider.dart';
import '../theme/tokens.dart';

class SpendPromptScreen extends StatefulWidget {
  final int walletId;
  const SpendPromptScreen({super.key, required this.walletId});

  @override
  State<SpendPromptScreen> createState() => _SpendPromptScreenState();
}

class _SpendPromptScreenState extends State<SpendPromptScreen> {
  int _pct = 5;
  static const _quickOpts = [1, 5, 10, 15, 25];

  String _fmt(int n) => 'TZS ${n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSub = isDark ? AppColors.darkTextSub : AppColors.lightTextSub;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return Consumer<WalletProvider>(
      builder: (context, provider, _) {
        final wallet = provider.getWallet(widget.walletId);
        final estMonthly = wallet.goal > 0 ? (wallet.goal * _pct / 100 / 12).round() : 0;

        return Scaffold(
          backgroundColor: bg,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Celebration header
                      Column(
                        children: [
                          const SizedBox(height: 8),
                          Container(
                            width: 64, height: 64,
                            decoration: BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
                            child: const Center(child: Text('🎉', style: TextStyle(fontSize: 28))),
                          ),
                          const SizedBox(height: 12),
                          const Text('MFUKO UMEUNDWA!', style: TextStyle(fontSize: 10, letterSpacing: 1.2, color: AppColors.success, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text('${wallet.emoji} ${wallet.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: text)),
                          const SizedBox(height: 20),
                        ],
                      ),

                      // Auto-save feature box
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          color: AppColors.orange.withAlpha(21),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.orange.withAlpha(51)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 36, height: 36,
                                  decoration: BoxDecoration(color: AppColors.orange, borderRadius: BorderRadius.circular(10)),
                                  child: const Center(child: Text('✨', style: TextStyle(fontSize: 20))),
                                ),
                                const SizedBox(width: 10),
                                Text('Akiba Kiotomatiki', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: text)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Kila wakati unaposhughulika na pesa kwa app — kulipa bili, kutuma kwa simu, manunuzi — asilimia ndogo itahifadhiwa kwa mfuko huu kiotomatiki.', style: TextStyle(fontSize: 13, color: textSub, height: 1.6)),
                          ],
                        ),
                      ),

                      // Big percentage display
                      Column(
                        children: [
                          Text('Asilimia ya kuhifadhi', style: TextStyle(fontSize: 13, color: textSub)),
                          const SizedBox(height: 6),
                          Text('$_pct%', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w900, color: AppColors.orange, height: 1)),
                          const SizedBox(height: 6),
                          Text('ya kila matumizi ya app', style: TextStyle(fontSize: 11, color: textMuted)),
                          if (estMonthly > 0) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(color: isDark ? AppColors.blueDark : AppColors.blueLight, borderRadius: BorderRadius.circular(10)),
                              child: Text('≈ ${_fmt(estMonthly)} / mwezi', style: const TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w600)),
                            ),
                          ],
                          const SizedBox(height: 20),
                        ],
                      ),

                      // Quick options
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: _quickOpts.map((p) => GestureDetector(
                          onTap: () => setState(() => _pct = p),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: _pct == p ? AppColors.orange : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: _pct == p ? AppColors.orange : border, width: 1.5),
                            ),
                            child: Text('$p%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _pct == p ? Colors.white : text)),
                          ),
                        )).toList(),
                      ),
                      const SizedBox(height: 18),

                      // Slider
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: AppColors.orange,
                                inactiveTrackColor: border,
                                thumbColor: AppColors.orange,
                                overlayColor: AppColors.orange.withAlpha(30),
                              ),
                              child: Slider(
                                value: _pct.toDouble(),
                                min: 1,
                                max: 50,
                                onChanged: (v) => setState(() => _pct = v.round()),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('1%', style: TextStyle(fontSize: 10, color: textMuted)),
                                Text('25%', style: TextStyle(fontSize: 10, color: textMuted)),
                                Text('50%', style: TextStyle(fontSize: 10, color: textMuted)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            provider.updateWallet(provider.getWallet(widget.walletId).copyWith(autoSavePct: _pct));
                            Navigator.of(context).pushNamedAndRemoveUntil('/detail', (r) => r.isFirst, arguments: widget.walletId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('✅ Akiba kiotomatiki ya $_pct% imeanzishwa!'), backgroundColor: AppColors.success),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 4,
                            shadowColor: AppColors.orange.withAlpha(85),
                          ),
                          child: Text('Anzisha kwa $_pct%', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil('/detail', (r) => r.isFirst, arguments: widget.walletId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('✅ Mfuko umeundwa!'), backgroundColor: AppColors.success),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: textSub,
                            side: BorderSide(color: border, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('Ruka kwa Sasa', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text('Unaweza kuwasha au kuzima wakati wowote katika mipangilio ya mfuko', style: TextStyle(fontSize: 11, color: textMuted), textAlign: TextAlign.center),
                      const SizedBox(height: 4),
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
