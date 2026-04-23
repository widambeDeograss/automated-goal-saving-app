import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/wallet_provider.dart';
import '../theme/tokens.dart';

class EditWalletScreen extends StatefulWidget {
  final int walletId;
  const EditWalletScreen({super.key, required this.walletId});

  @override
  State<EditWalletScreen> createState() => _EditWalletScreenState();
}

class _EditWalletScreenState extends State<EditWalletScreen> {
  late TextEditingController _nameController;
  late TextEditingController _goalController;
  late String _emoji;
  late int _goal;

  final _emojis = ['🎯', '🏖', '🚗', '🏠', '💍', '✈️', '📱', '🎓', '🛡', '💊', '🎸', '⚽'];

  String _fmt(int n) => 'TZS ${n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

  @override
  void initState() {
    super.initState();
    final wallet = context.read<WalletProvider>().getWallet(widget.walletId);
    _emoji = wallet.emoji;
    _goal = wallet.goal;
    _nameController = TextEditingController(text: wallet.name);
    _goalController = TextEditingController(text: wallet.goal.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
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
    final goalBelowBalance = _goal < wallet.balance;
    final canSave = _nameController.text.trim().isNotEmpty && !goalBelowBalance;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: Icon(Icons.chevron_left, color: textSub, size: 24), onPressed: () => Navigator.pop(context)),
                  Text('Hariri Akiba', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text)),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 20),

              Text('Badilisha alama', style: TextStyle(fontSize: 13, color: textSub)),
              const SizedBox(height: 12),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1,
                ),
                itemCount: _emojis.length,
                itemBuilder: (_, i) {
                  final e = _emojis[i];
                  final selected = _emoji == e;
                  return GestureDetector(
                    onTap: () => setState(() => _emoji = e),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.blueLight : surface,
                        border: Border.all(color: selected ? AppColors.blue : border, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(e, style: const TextStyle(fontSize: 20)),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              Text('JINA LA MFUKO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSub, letterSpacing: 0.5)),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  filled: true, fillColor: surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: _nameController.text.isNotEmpty ? AppColors.blue : border, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
                  ),
                ),
                style: TextStyle(fontSize: 14, color: text),
              ),
              const SizedBox(height: 14),

              Text('LENGO JIPYA (TZS)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSub, letterSpacing: 0.5)),
              const SizedBox(height: 6),
              TextField(
                controller: _goalController,
                keyboardType: TextInputType.number,
                onChanged: (v) => setState(() => _goal = int.tryParse(v) ?? 0),
                decoration: InputDecoration(
                  filled: true, fillColor: surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: _goal > 0 ? AppColors.orange : border, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.orange, width: 1.5),
                  ),
                ),
                style: TextStyle(fontSize: 14, color: text),
              ),

              if (goalBelowBalance)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('Lengo haliwezi kuwa chini ya salio ya sasa (${_fmt(wallet.balance)})',
                      style: const TextStyle(fontSize: 11, color: AppColors.danger)),
                ),

              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canSave
                      ? () {
                          final updated = wallet.copyWith(
                            name: _nameController.text.trim(),
                            emoji: _emoji,
                            goal: _goal,
                          );
                          context.read<WalletProvider>().updateWallet(updated);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('✅ Mabadiliko yamehifadhiwa!'),
                              backgroundColor: Color(0xFF22C55E),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canSave ? AppColors.blue : Colors.grey[300],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Hifadhi Mabadiliko', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
