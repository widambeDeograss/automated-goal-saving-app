import 'package:flutter/material.dart';
import '../models/wallet.dart';
import '../theme/tokens.dart';
import '../widgets/step_dots.dart';

class CreateStep1Screen extends StatefulWidget {
  final WalletDraft draft;
  const CreateStep1Screen({super.key, required this.draft});

  @override
  State<CreateStep1Screen> createState() => _CreateStep1ScreenState();
}

class _CreateStep1ScreenState extends State<CreateStep1Screen> {
  final _controller = TextEditingController();
  late WalletDraft _draft;

  final _emojis = ['🎯', '🏖', '🚗', '🏠', '💍', '✈️', '📱', '🎓', '🛡', '💊', '🎸', '⚽'];

  @override
  void initState() {
    super.initState();
    _draft = widget.draft;
    _controller.text = _draft.name;
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
    final canProceed = _draft.name.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top nav
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: textSub, size: 20),
                    onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                  ),
                  Text('Unda Akiba Mpya', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text)),
                  const SizedBox(width: 48),
                ],
              ),
              const StepDots(total: 4, current: 0),

              Text('Ita mfuko wako', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: text)),
              const SizedBox(height: 4),
              Text('Chagua jina na alama ya mfuko wako wa akiba', style: TextStyle(fontSize: 13, color: textSub)),
              const SizedBox(height: 24),

              // Emoji grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: _emojis.length,
                itemBuilder: (_, i) {
                  final e = _emojis[i];
                  final selected = _draft.emoji == e;
                  return GestureDetector(
                    onTap: () => setState(() => _draft.emoji = e),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.blueLight : surface,
                        border: Border.all(color: selected ? AppColors.blue : border, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(e, style: const TextStyle(fontSize: 22)),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Name input
              Text('JINA LA MFUKO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSub, letterSpacing: 0.5)),
              const SizedBox(height: 6),
              TextField(
                controller: _controller,
                onChanged: (v) => setState(() => _draft.name = v),
                decoration: InputDecoration(
                  hintText: 'mf. Likizo ya Zanzibar',
                  hintStyle: TextStyle(color: textSub),
                  filled: true,
                  fillColor: surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: _draft.name.isNotEmpty ? AppColors.blue : border, width: 1.5),
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
                  onPressed: canProceed
                      ? () => Navigator.of(context).pushNamed('/create/step2', arguments: _draft)
                      : null,
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
