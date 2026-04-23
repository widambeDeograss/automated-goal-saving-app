import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/wallet_provider.dart';
import '../theme/tokens.dart';

class FundWalletScreen extends StatefulWidget {
  final int walletId;
  const FundWalletScreen({super.key, required this.walletId});

  @override
  State<FundWalletScreen> createState() => _FundWalletScreenState();
}

class _FundWalletScreenState extends State<FundWalletScreen> {
  final _controller = TextEditingController();
  int? _amount;
  final _quickAmounts = [10000, 50000, 100000, 500000];

  String _fmt(int n) => 'TZS ${n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

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
    final valid = _amount != null && _amount! >= 1000;

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
                  Text('Weka Pesa', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text)),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 20),

              // Wallet info card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: wallet.color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text(wallet.emoji, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Unatuma pesa kwa', style: TextStyle(fontSize: 11, color: Colors.white70)),
                        Text(wallet.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                        const SizedBox(height: 2),
                        Text('Salio: ${_fmt(wallet.balance)}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text('Chagua au weka kiasi', style: TextStyle(fontSize: 13, color: textSub)),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 3.5,
                ),
                itemCount: _quickAmounts.length,
                itemBuilder: (_, i) {
                  final q = _quickAmounts[i];
                  final selected = _amount == q;
                  return GestureDetector(
                    onTap: () => setState(() { _amount = q; _controller.text = q.toString(); }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: selected ? wallet.color.withAlpha(34) : surface,
                        border: Border.all(color: selected ? wallet.color : border, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(_fmt(q), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? wallet.color : text)),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                onChanged: (v) => setState(() => _amount = int.tryParse(v)),
                decoration: InputDecoration(
                  hintText: 'Weka kiasi (TZS)',
                  hintStyle: TextStyle(color: textSub),
                  filled: true, fillColor: surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: valid ? wallet.color : border, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: wallet.color, width: 1.5),
                  ),
                ),
                style: TextStyle(fontSize: 15, color: text),
              ),

              if (_amount != null && _amount! < 1000)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('Kiwango cha chini ni TZS 1,000', style: const TextStyle(fontSize: 11, color: AppColors.danger)),
                ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: valid
                      ? () {
                          context.read<WalletProvider>().fundWallet(widget.walletId, _amount!);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('✅ ${_fmt(_amount!)} imetumwa!'),
                              backgroundColor: const Color(0xFF22C55E),
                              behavior: SnackBarBehavior.floating,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: valid ? wallet.color : Colors.grey[300],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text(valid ? 'Tuma ${_fmt(_amount!)}' : 'Tuma Pesa', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
