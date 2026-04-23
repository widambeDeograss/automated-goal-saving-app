import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/wallet.dart';
import '../theme/tokens.dart';
import '../widgets/step_dots.dart';

class CreateLockPeriodScreen extends StatefulWidget {
  final WalletDraft draft;
  const CreateLockPeriodScreen({super.key, required this.draft});

  @override
  State<CreateLockPeriodScreen> createState() => _CreateLockPeriodScreenState();
}

class _CreateLockPeriodScreenState extends State<CreateLockPeriodScreen> {
  late WalletDraft _draft;
  bool _custom = false;
  final _customController = TextEditingController();

  final _quickOpts = [1, 3, 6, 12];

  String _unlockPreview(int months) {
    final d = DateTime.now();
    final unlock = DateTime(d.year, d.month + months, d.day);
    return DateFormat('dd MMM yyyy').format(unlock);
  }

  @override
  void initState() {
    super.initState();
    _draft = widget.draft;
    _customController.text = _draft.lockMonths.toString();
  }

  @override
  void dispose() {
    _customController.dispose();
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
    final lock = _draft.lockMonths;

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
                  Text('Muda wa Kufunga', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text)),
                  const SizedBox(width: 48),
                ],
              ),
              const StepDots(total: 4, current: 3),

              Text('Lini unaweza kutoa?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: text)),
              const SizedBox(height: 4),
              Text('Weka muda wa chini kabla ya kutoa pesa. Hii inakusaidia kudumisha akiba yako.', style: TextStyle(fontSize: 13, color: textSub, height: 1.5)),
              const SizedBox(height: 24),

              // Big display
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(color: AppColors.blueLight, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: const Icon(Icons.lock_outline_rounded, size: 32, color: AppColors.blue),
                    ),
                    const SizedBox(height: 12),
                    Text('$lock', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: AppColors.blue, height: 1)),
                    Text(lock == 1 ? 'mwezi' : 'miezi', style: TextStyle(fontSize: 14, color: textSub)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.orangeLight, borderRadius: BorderRadius.circular(8)),
                      child: Text('Unaweza kutoa tangu ${_unlockPreview(lock)}',
                          style: const TextStyle(fontSize: 12, color: AppColors.orange, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Quick options
              if (!_custom) ...[
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 2.2,
                  ),
                  itemCount: _quickOpts.length,
                  itemBuilder: (_, i) {
                    final m = _quickOpts[i];
                    final selected = lock == m;
                    return GestureDetector(
                      onTap: () => setState(() => _draft.lockMonths = m),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.blueLight : surface,
                          border: Border.all(color: selected ? AppColors.blue : border, width: 1.5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('$m', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: selected ? AppColors.blue : text)),
                            Text(m == 1 ? 'mwezi' : 'miezi', style: TextStyle(fontSize: 11, color: selected ? AppColors.blue : textSub)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => setState(() { _custom = true; _customController.text = lock.toString(); }),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      border: Border.all(color: border, width: 1.5, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text('+ Weka muda wako mwenyewe', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textSub)),
                  ),
                ),
              ] else ...[
                Text('MIEZI (1–60)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSub, letterSpacing: 0.5)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _customController,
                        keyboardType: TextInputType.number,
                        onChanged: (v) {
                          final n = int.tryParse(v) ?? 1;
                          setState(() => _draft.lockMonths = n.clamp(1, 60));
                        },
                        decoration: InputDecoration(
                          filled: true, fillColor: surface,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.blue, width: 1.5)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.blue, width: 1.5)),
                        ),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: text),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _custom = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                        decoration: BoxDecoration(color: surface, border: Border.all(color: border, width: 1.5), borderRadius: BorderRadius.circular(12)),
                        child: Text('Rudi', style: TextStyle(fontSize: 13, color: textSub)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Kiwango cha chini: miezi 1 · Kiwango cha juu: miezi 60', style: TextStyle(fontSize: 11, color: textMuted)),
              ],

              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.access_time_rounded, size: 16, color: AppColors.blue),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 12, color: AppColors.blue, height: 1.5),
                          children: [
                            TextSpan(text: 'Muda wa chini uliopendekezwa ni '),
                            TextSpan(text: 'miezi 3', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: '. Muda mrefu zaidi unakusaidia kufikia malengo makubwa.'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/create/confirm', arguments: _draft),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                    shadowColor: AppColors.blue.withAlpha(68),
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
