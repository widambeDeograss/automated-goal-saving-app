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
  _IconItem? _hoveredIcon;

  static const _icons = [
    _IconItem('🎯', 'Lengo'),
    _IconItem('🏖', 'Likizo'),
    _IconItem('🚗', 'Gari'),
    _IconItem('🏠', 'Nyumba'),
    _IconItem('💍', 'Harusi'),
    _IconItem('✈️', 'Safari'),
    _IconItem('📱', 'Simu'),
    _IconItem('🎓', 'Masomo'),
    _IconItem('🛡', 'Dharura'),
    _IconItem('💊', 'Matibabu'),
    _IconItem('🎸', 'Burudani'),
    _IconItem('⚽', 'Michezo'),
  ];

  static final _iconLabels = _icons.map((i) => i.label).toSet();

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

  void _handleIconTap(_IconItem item) {
    setState(() {
      _draft.emoji = item.emoji;
      final shouldPrefill = _draft.name.trim().isEmpty || _iconLabels.contains(_draft.name.trim());
      if (shouldPrefill) {
        _draft.name = item.label;
        _controller.text = item.label;
        _controller.selection = TextSelection.fromPosition(TextPosition(offset: item.label.length));
      }
    });
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
    final isGroup = _draft.kind == WalletType.group;
    final accent = isGroup ? (isDark ? AppColors.purpleDark : AppColors.purple) : AppColors.blue;
    final accentLight = isGroup ? (isDark ? AppColors.purpleDarkBg : AppColors.purpleLight) : (isDark ? AppColors.blueDark : AppColors.blueLight);
    final canProceed = _draft.name.trim().isNotEmpty;
    final totalSteps = isGroup ? 4 : 3;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Top nav
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
                        child: Padding(padding: const EdgeInsets.all(4), child: Icon(Icons.close, color: textSub, size: 20)),
                      ),
                      Text('Unda Akiba Mpya', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text)),
                      const SizedBox(width: 28),
                    ],
                  ),
                  StepDots(total: totalSteps, current: 0),

                  Text('Ita mfuko wako', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: text)),
                  const SizedBox(height: 4),
                  Text('Chagua alama — jina linapendekezwa kiotomatiki, lakini unaweza kuongeza maelezo yako', style: TextStyle(fontSize: 13, color: textSub)),
                  const SizedBox(height: 16),

                  // Hover preview banner
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: _hoveredIcon != null ? accentLight : surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _hoveredIcon != null ? accent.withAlpha(68) : border),
                    ),
                    child: _hoveredIcon != null
                        ? Row(
                            children: [
                              Text(_hoveredIcon!.emoji, style: const TextStyle(fontSize: 22)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('PENDEKEZO LA JINA', style: TextStyle(fontSize: 10, color: textSub, letterSpacing: 0.5)),
                                    Text(_hoveredIcon!.label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: accent)),
                                  ],
                                ),
                              ),
                              Icon(Icons.info_outline_rounded, size: 14, color: accent),
                            ],
                          )
                        : Row(
                            children: [
                              Icon(Icons.info_outline_rounded, size: 16, color: textMuted),
                              const SizedBox(width: 10),
                              Expanded(child: Text('Bofya alama yoyote — jina litajaa kiotomatiki', style: TextStyle(fontSize: 12, color: textSub, height: 1.4))),
                            ],
                          ),
                  ),

                  // Emoji grid (4 columns with labels)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: _icons.length,
                    itemBuilder: (_, i) {
                      final item = _icons[i];
                      final selected = _draft.emoji == item.emoji;
                      return GestureDetector(
                        onTap: () => _handleIconTap(item),
                        onLongPressStart: (_) => setState(() => _hoveredIcon = item),
                        onLongPressEnd: (_) => setState(() => _hoveredIcon = null),
                        child: MouseRegion(
                          onEnter: (_) => setState(() => _hoveredIcon = item),
                          onExit: (_) => setState(() => _hoveredIcon = null),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                            decoration: BoxDecoration(
                              color: selected ? accentLight : surface,
                              border: Border.all(color: selected ? accent : border, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(item.emoji, style: const TextStyle(fontSize: 24)),
                                const SizedBox(height: 4),
                                Text(item.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: selected ? accent : textSub, letterSpacing: 0.2), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Name input
                  Text('JINA LA MFUKO (unaweza kuongeza maelezo)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSub, letterSpacing: 0.5)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _controller,
                    onChanged: (v) => setState(() => _draft.name = v),
                    decoration: InputDecoration(
                      hintText: 'mf. Likizo ya Zanzibar',
                      hintStyle: TextStyle(color: textMuted),
                      filled: true,
                      fillColor: surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _draft.name.isNotEmpty ? accent : border, width: 1.5)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: accent, width: 1.5)),
                    ),
                    style: TextStyle(fontSize: 14, color: text),
                  ),
                  if (_draft.name.isNotEmpty && _iconLabels.contains(_draft.name.trim()))
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline_rounded, size: 11, color: textMuted),
                          const SizedBox(width: 4),
                          Text('Andika zaidi ili kuweka maelezo (mf. "${_draft.name} ya Zanzibar")', style: TextStyle(fontSize: 11, color: textMuted)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canProceed
                      ? () => Navigator.of(context).pushNamed('/create/step2', arguments: _draft)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canProceed ? accent : const Color(0xFFCCCCCC),
                    disabledBackgroundColor: const Color(0xFFCCCCCC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Endelea', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconItem {
  final String emoji;
  final String label;
  const _IconItem(this.emoji, this.label);
}
