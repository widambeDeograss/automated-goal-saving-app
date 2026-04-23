import 'package:flutter/material.dart';
import '../models/wallet.dart';
import '../theme/tokens.dart';
import '../widgets/step_dots.dart';
import '../widgets/info_banner.dart';

class CreateStep3Screen extends StatefulWidget {
  final WalletDraft draft;
  const CreateStep3Screen({super.key, required this.draft});

  @override
  State<CreateStep3Screen> createState() => _CreateStep3ScreenState();
}

class _CreateStep3ScreenState extends State<CreateStep3Screen> {
  late WalletDraft _draft;
  final _pctOptions = [1, 5, 10, 15, 20, 25];

  String _fmt(int n) => 'TZS ${n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

  @override
  void initState() {
    super.initState();
    _draft = widget.draft;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSub = isDark ? AppColors.darkTextSub : AppColors.lightTextSub;
    final pct = _draft.autoSavePct;
    final monthlyEst = _draft.goal != null ? (_draft.goal! * pct / 100 / 12).round() : 0;

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
                  Text('Kiwango cha Akiba', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text)),
                  const SizedBox(width: 48),
                ],
              ),
              const StepDots(total: 4, current: 2),

              Text('Weka kiwango cha akiba', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: text)),
              const SizedBox(height: 4),
              Text('Asilimia ngapi ya pesa zinazoingia utakataka kuhifadhi kiotomatiki?', style: TextStyle(fontSize: 13, color: textSub)),
              const SizedBox(height: 24),

              // Big pct display
              Center(
                child: Column(
                  children: [
                    Text('$pct%', style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900, color: AppColors.orange, height: 1)),
                    const SizedBox(height: 4),
                    Text('ya kila pesa inayoingia', style: TextStyle(fontSize: 13, color: textSub)),
                    if (_draft.goal != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(8)),
                        child: Text('≈ ${_fmt(monthlyEst)} / mwezi', style: const TextStyle(fontSize: 12, color: AppColors.blue)),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Quick % pills
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _pctOptions.map((p) {
                  final selected = pct == p;
                  return GestureDetector(
                    onTap: () => setState(() => _draft.autoSavePct = p),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.orange : Colors.transparent,
                        border: Border.all(color: selected ? AppColors.orange : border, width: 1.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('$p%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? Colors.white : text)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

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
                        trackHeight: 6,
                      ),
                      child: Slider(
                        value: pct.toDouble(),
                        min: 1,
                        max: 50,
                        divisions: 49,
                        onChanged: (v) => setState(() => _draft.autoSavePct = v.round()),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('1%', style: TextStyle(fontSize: 11, color: textSub)),
                        Text('50%', style: TextStyle(fontSize: 11, color: textSub)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              InfoBanner(
                text: 'Kila pesa inayoingia kwenye akaunti yako, $pct% itahamishiwa mfuko huu kiotomatiki.',
                bgColor: AppColors.blueLight,
                textColor: AppColors.blue,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/create/lock', arguments: _draft),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Endelea', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
