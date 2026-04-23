import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/wallet_provider.dart';
import '../theme/tokens.dart';

class GoalReachedScreen extends StatefulWidget {
  final int walletId;
  const GoalReachedScreen({super.key, required this.walletId});

  @override
  State<GoalReachedScreen> createState() => _GoalReachedScreenState();
}

class _GoalReachedScreenState extends State<GoalReachedScreen> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnim;

  String _fmt(int n) => 'TZS ${n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _bounceAnim = CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.read<WalletProvider>().getWallet(widget.walletId);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSub = isDark ? AppColors.darkTextSub : AppColors.lightTextSub;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Celebration rings
              AnimatedBuilder(
                animation: _bounceAnim,
                builder: (_, child) => Transform.scale(
                  scale: 0.95 + 0.05 * _bounceAnim.value,
                  child: child,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120, height: 120,
                      decoration: BoxDecoration(color: AppColors.success.withAlpha(34), shape: BoxShape.circle),
                    ),
                    Container(
                      width: 90, height: 90,
                      decoration: BoxDecoration(color: AppColors.success.withAlpha(68), shape: BoxShape.circle),
                    ),
                    Container(
                      width: 66, height: 66,
                      decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: Text(wallet.emoji, style: const TextStyle(fontSize: 32)),
                    ),
                    // Floating decorations
                    ..._buildDecorations(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text('HONGERA SANA! 🎊', style: TextStyle(fontSize: 11, letterSpacing: 1.5, color: AppColors.success, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('Lengo Limefikiwa!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: text)),
              const SizedBox(height: 8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontSize: 14, color: textSub, height: 1.6),
                  children: [
                    const TextSpan(text: 'Umefanikiwa kukusanya '),
                    TextSpan(text: _fmt(wallet.balance), style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                    const TextSpan(text: ' kwa mfuko wa '),
                    TextSpan(text: '"${wallet.name}"', style: TextStyle(color: text, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Summary card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    const Text('JUMLA ILIYOKUSANYWA', style: TextStyle(fontSize: 11, color: Color(0xFF15803D), letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    Text(_fmt(wallet.balance), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.success)),
                    const SizedBox(height: 4),
                    Text('Lengo: ${_fmt(wallet.goal)} ✓', style: const TextStyle(fontSize: 12, color: Color(0xFF15803D))),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/withdraw', arguments: widget.walletId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                    shadowColor: AppColors.success.withAlpha(68),
                  ),
                  child: const Text('Toa Pesa Sasa', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: text,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    side: BorderSide(color: border, width: 1.5),
                  ),
                  child: const Text('Rudi kwa Mifuko', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDecorations() {
    final items = ['⭐', '🎉', '✨', '🏆', '🌟'];
    final offsets = [
      const Offset(-50, -40),
      const Offset(0, -65),
      const Offset(55, -35),
      const Offset(-55, 10),
      const Offset(50, 15),
    ];
    return List.generate(items.length, (i) => Positioned(
      left: 60 + offsets[i].dx,
      top: 60 + offsets[i].dy,
      child: AnimatedBuilder(
        animation: _bounceController,
        builder: (_, child) => Transform.rotate(
          angle: 0.2 * (i % 2 == 0 ? 1 : -1) * _bounceController.value,
          child: child,
        ),
        child: Text(items[i], style: const TextStyle(fontSize: 18)),
      ),
    ));
  }
}
