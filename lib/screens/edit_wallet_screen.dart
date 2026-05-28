import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/wallet.dart';
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
  late TextEditingController _lockController;
  late String _emoji;
  late int _goal;
  late int _lockM;
  late int _autoPct;
  late bool _autoOn;

  static const _icons = [
    ('🎯', 'Lengo'), ('🏖', 'Likizo'), ('🚗', 'Gari'), ('🏠', 'Nyumba'),
    ('💍', 'Harusi'), ('✈️', 'Safari'), ('📱', 'Simu'), ('🎓', 'Masomo'),
    ('🛡', 'Dharura'), ('💊', 'Matibabu'), ('🎸', 'Burudani'), ('⚽', 'Michezo'),
  ];

  static const _lockOpts = [1, 3, 6, 12, 24];

  String _fmt(int n) => 'TZS ${n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

  String _fmtDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ago', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  void initState() {
    super.initState();
    final wallet = context.read<WalletProvider>().getWallet(widget.walletId);
    _emoji = wallet.emoji;
    _goal = wallet.goal;
    _lockM = wallet.lockMonths;
    _autoPct = wallet.autoSavePct > 0 ? wallet.autoSavePct : 5;
    _autoOn = wallet.autoSavePct > 0;
    _nameController = TextEditingController(text: wallet.name);
    _goalController = TextEditingController(text: wallet.goal.toString());
    _lockController = TextEditingController(text: wallet.lockMonths.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
    _lockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WalletProvider>();
    final wallet = provider.getWallet(widget.walletId);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final surfaceAlt = isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSub = isDark ? AppColors.darkTextSub : AppColors.lightTextSub;
    final shadow = isDark ? const Color(0x66000000) : const Color(0x14000000);
    final isGroup = wallet.isGroup;
    final accent = isGroup ? (isDark ? AppColors.purpleDark : AppColors.purple) : AppColors.blue;
    final accentLight = isGroup ? (isDark ? AppColors.purpleDarkBg : AppColors.purpleLight) : (isDark ? AppColors.blueDark : AppColors.blueLight);

    final goalBelowBalance = _goal < wallet.balance;
    final nameOk = _nameController.text.trim().isNotEmpty;
    final canSave = nameOk && !goalBelowBalance && _goal > 0;

    final newUnlockPreview = DateTime(wallet.createdAt.year, wallet.createdAt.month + _lockM, wallet.createdAt.day);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(padding: const EdgeInsets.all(4), child: Icon(Icons.arrow_back_ios_new_rounded, color: textSub, size: 20)),
                  ),
                  Text('Mipangilio ya Mfuko', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text)),
                  const SizedBox(width: 28),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // ─── BASIC INFO ───
                  _Section(
                    title: 'MAELEZO YA MSINGI',
                    accentColor: accent,
                    surface: surface,
                    shadow: shadow,
                    children: [
                      Text('ALAMA', style: TextStyle(fontSize: 11, color: textSub, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6, crossAxisSpacing: 6, mainAxisSpacing: 6, childAspectRatio: 1,
                        ),
                        itemCount: _icons.length,
                        itemBuilder: (_, i) {
                          final (emoji, label) = _icons[i];
                          final selected = _emoji == emoji;
                          return GestureDetector(
                            onTap: () => setState(() => _emoji = emoji),
                            child: Tooltip(
                              message: label,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                decoration: BoxDecoration(
                                  color: selected ? accentLight : surfaceAlt,
                                  border: Border.all(color: selected ? accent : border, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(emoji, style: const TextStyle(fontSize: 18)),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      Text('JINA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textSub, letterSpacing: 0.5)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _nameController,
                        onChanged: (_) => setState(() {}),
                        style: TextStyle(fontSize: 14, color: text),
                        decoration: InputDecoration(
                          filled: true, fillColor: bg,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: nameOk ? accent : AppColors.danger, width: 1.5)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: accent, width: 1.5)),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text('LENGO (TZS)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textSub, letterSpacing: 0.5)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _goalController,
                        keyboardType: TextInputType.number,
                        onChanged: (v) => setState(() => _goal = int.tryParse(v) ?? 0),
                        style: TextStyle(fontSize: 14, color: text),
                        decoration: InputDecoration(
                          filled: true, fillColor: bg,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: goalBelowBalance ? AppColors.danger : accent, width: 1.5)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: goalBelowBalance ? AppColors.danger : accent, width: 1.5)),
                        ),
                      ),
                      if (goalBelowBalance)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline_rounded, size: 11, color: AppColors.danger),
                              const SizedBox(width: 4),
                              Text('Lengo haliwezi kuwa chini ya salio ya sasa (${_fmt(wallet.balance)})', style: const TextStyle(fontSize: 11, color: AppColors.danger)),
                            ],
                          ),
                        ),
                    ],
                  ),

                  // ─── LOCK PERIOD ───
                  _Section(
                    title: 'MUDA WA KUFUNGA',
                    accentColor: AppColors.blue,
                    surface: surface,
                    shadow: shadow,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(color: isDark ? AppColors.blueDark : AppColors.blueLight, borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            const Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.blue),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    wallet.isLocked ? 'Umefungwa · Miezi ${wallet.monthsRemaining} iliyobaki' : 'Umefunguliwa',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.blue),
                                  ),
                                  Text(
                                    'Tarehe ya kufungua: ${_fmtDate(wallet.unlockDate)}',
                                    style: TextStyle(fontSize: 10, color: textSub),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text('BADILISHA MUDA (MIEZI)', style: TextStyle(fontSize: 11, color: textSub, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Row(
                        children: _lockOpts.map((m) => Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() { _lockM = m; _lockController.text = m.toString(); }),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _lockM == m ? (isDark ? AppColors.blueDark : AppColors.blueLight) : surfaceAlt,
                                border: Border.all(color: _lockM == m ? AppColors.blue : border, width: 1.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('$m', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _lockM == m ? AppColors.blue : text)),
                            ),
                          ),
                        )).toList(),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _lockController,
                        keyboardType: TextInputType.number,
                        onChanged: (v) => setState(() => _lockM = (int.tryParse(v) ?? 1).clamp(1, 60)),
                        style: TextStyle(fontSize: 13, color: text),
                        decoration: InputDecoration(
                          hintText: 'Au weka miezi yako mwenyewe (1-60)',
                          hintStyle: TextStyle(color: textSub, fontSize: 12),
                          filled: true, fillColor: bg,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: border)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.blue, width: 1.5)),
                        ),
                      ),
                      if (_lockM != wallet.lockMonths)
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(color: isDark ? AppColors.orangeDark : AppColors.orangeLight, borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline_rounded, size: 12, color: AppColors.orange),
                              const SizedBox(width: 8),
                              Text('Tarehe mpya ya kufungua: ${_fmtDate(newUnlockPreview)}', style: const TextStyle(fontSize: 11, color: AppColors.orange)),
                            ],
                          ),
                        ),
                    ],
                  ),

                  // ─── AUTO-SAVE (personal only) ───
                  if (!isGroup)
                    _Section(
                      title: 'AKIBA KIOTOMATIKI YA MATUMIZI',
                      accentColor: AppColors.orange,
                      surface: surface,
                      shadow: shadow,
                      children: [
                        Row(
                          children: [
                            const Text('✨', style: TextStyle(fontSize: 22)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Hifadhi kila matumizi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: text)),
                                  Text('Asilimia ya kila matumizi ya app itahifadhiwa', style: TextStyle(fontSize: 11, color: textSub, height: 1.4)),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _autoOn = !_autoOn),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 46, height: 26,
                                decoration: BoxDecoration(
                                  color: _autoOn ? AppColors.orange : border,
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: AnimatedAlign(
                                  duration: const Duration(milliseconds: 200),
                                  alignment: _autoOn ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Container(
                                    width: 20, height: 20,
                                    margin: const EdgeInsets.symmetric(horizontal: 3),
                                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Color(0x33000000), blurRadius: 3)]),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_autoOn) ...[
                          const SizedBox(height: 14),
                          Center(
                            child: Column(
                              children: [
                                Text('$_autoPct%', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.orange, height: 1)),
                                Text('ya kila matumizi ya app', style: TextStyle(fontSize: 11, color: textSub)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 6,
                            runSpacing: 6,
                            children: [1, 5, 10, 15, 25].map((p) => GestureDetector(
                              onTap: () => setState(() => _autoPct = p),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _autoPct == p ? AppColors.orange : Colors.transparent,
                                  border: Border.all(color: _autoPct == p ? AppColors.orange : border, width: 1.5),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text('$p%', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: _autoPct == p ? Colors.white : text)),
                              ),
                            )).toList(),
                          ),
                          const SizedBox(height: 12),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppColors.orange,
                              inactiveTrackColor: border,
                              thumbColor: AppColors.orange,
                              overlayColor: AppColors.orange.withAlpha(30),
                            ),
                            child: Slider(
                              value: _autoPct.toDouble(),
                              min: 1, max: 50,
                              onChanged: (v) => setState(() => _autoPct = v.round()),
                            ),
                          ),
                        ],
                      ],
                    ),

                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: canSave
                          ? () {
                              final updated = wallet.copyWith(
                                name: _nameController.text.trim(),
                                emoji: _emoji,
                                goal: _goal,
                                lockMonths: _lockM,
                                autoSavePct: isGroup ? 0 : (_autoOn ? _autoPct : 0),
                              );
                              context.read<WalletProvider>().updateWallet(updated);
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('✅ Mabadiliko yamehifadhiwa!'),
                                  backgroundColor: AppColors.success,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canSave ? accent : const Color(0xFFCCCCCC),
                        disabledBackgroundColor: const Color(0xFFCCCCCC),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: canSave ? 4 : 0,
                        shadowColor: accent.withAlpha(85),
                      ),
                      child: const Text('Hifadhi Mabadiliko', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Color accentColor;
  final Color surface;
  final Color shadow;
  final List<Widget> children;

  const _Section({required this.title, required this.accentColor, required this.surface, required this.shadow, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: shadow, blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: accentColor, letterSpacing: 1)),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}
