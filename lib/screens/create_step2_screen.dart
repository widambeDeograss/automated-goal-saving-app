import 'package:flutter/material.dart';
import '../models/wallet.dart';
import '../theme/tokens.dart';
import '../widgets/step_dots.dart';

class CreateStep2Screen extends StatefulWidget {
  final WalletDraft draft;
  const CreateStep2Screen({super.key, required this.draft});

  @override
  State<CreateStep2Screen> createState() => _CreateStep2ScreenState();
}

class _CreateStep2ScreenState extends State<CreateStep2Screen> {
  final _controller = TextEditingController();
  late WalletDraft _draft;

  final _quickAmounts = [500000, 1000000, 2000000, 5000000];

  String _fmt(int n) => 'TZS ${n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

  @override
  void initState() {
    super.initState();
    _draft = widget.draft;
    if (_draft.goal != null) _controller.text = _draft.goal.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSub = isDark ? AppColors.darkTextSub : AppColors.lightTextSub;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final shadow = isDark ? const Color(0x66000000) : const Color(0x14000000);
    final canProceed = _draft.goal != null && _draft.goal! > 0;

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
                  Text('Weka Lengo', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text)),
                  const SizedBox(width: 48),
                ],
              ),
              StepDots(total: _draft.kind == WalletType.group ? 4 : 3, current: 1),

              Text('Kiasi cha lengo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: text)),
              const SizedBox(height: 4),
              Text('Unataka kukusanya kiasi gani?', style: TextStyle(fontSize: 13, color: textSub)),
              const SizedBox(height: 32),

              // Big display card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: shadow, blurRadius: 12, offset: const Offset(0, 2))],
                ),
                child: Column(
                  children: [
                    Text('${_draft.emoji} ${_draft.name}', style: TextStyle(fontSize: 11, color: textSub, letterSpacing: 0.8)),
                    const SizedBox(height: 6),
                    Text(
                      canProceed ? _fmt(_draft.goal!) : 'TZS 0',
                      style: TextStyle(
                        fontSize: 32, fontWeight: FontWeight.w800,
                        color: canProceed ? AppColors.blue : textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Quick picks
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 3.5,
                ),
                itemCount: _quickAmounts.length,
                itemBuilder: (_, i) {
                  final q = _quickAmounts[i];
                  final selected = _draft.goal == q;
                  return GestureDetector(
                    onTap: () {
                      setState(() { _draft.goal = q; _controller.text = q.toString(); });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.orangeLight : surface,
                        border: Border.all(color: selected ? AppColors.orange : border, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(_fmt(q), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? AppColors.orange : text)),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              Text('AU WEKA KIASI CHOCHOTE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSub, letterSpacing: 0.5)),
              const SizedBox(height: 6),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                onChanged: (v) => setState(() => _draft.goal = int.tryParse(v)),
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(color: textSub),
                  filled: true, fillColor: surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: canProceed ? AppColors.blue : border, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
                  ),
                ),
                style: TextStyle(fontSize: 14, color: text),
              ),
              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canProceed ? () => Navigator.of(context).pushNamed('/create/lock', arguments: _draft) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canProceed ? AppColors.blue : Colors.grey[300],
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
