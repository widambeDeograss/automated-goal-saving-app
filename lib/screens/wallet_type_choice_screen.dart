import 'package:flutter/material.dart';
import '../models/wallet.dart';
import '../theme/tokens.dart';

class WalletTypeChoiceScreen extends StatefulWidget {
  const WalletTypeChoiceScreen({super.key});

  @override
  State<WalletTypeChoiceScreen> createState() => _WalletTypeChoiceScreenState();
}

class _WalletTypeChoiceScreenState extends State<WalletTypeChoiceScreen> {
  WalletType? _selected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final surfaceAlt = isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSub = isDark ? AppColors.darkTextSub : AppColors.lightTextSub;
    final purple = isDark ? AppColors.purpleDark : AppColors.purple;
    final purpleLight = isDark ? AppColors.purpleDarkBg : AppColors.purpleLight;

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
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Icon(Icons.close, size: 20, color: textSub),
                    ),
                  ),
                  Text('Unda Akiba', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text)),
                  const SizedBox(width: 28),
                ],
              ),
              const SizedBox(height: 24),
              Text('Aina ya Akiba', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: text)),
              const SizedBox(height: 6),
              Text('Chagua aina ya mfuko unaoutaka kuanzisha', style: TextStyle(fontSize: 13, color: textSub)),
              const SizedBox(height: 24),

              // Personal card
              _TypeCard(
                selected: _selected == WalletType.personal,
                icon: Icons.person_outline_rounded,
                iconColor: AppColors.blue,
                iconBg: AppColors.blue.withAlpha(34),
                title: 'Akiba ya Mtu Mmoja',
                description: 'Akiba ya kibinafsi unayoidhibiti mwenyewe. Wewe pekee unaweza kuweka na kutoa pesa.',
                tags: const ['Faragha', 'Udhibiti kamili'],
                accentColor: AppColors.blue,
                accentLight: isDark ? AppColors.blueDark : AppColors.blueLight,
                borderColor: border,
                surface: surface,
                surfaceAlt: surfaceAlt,
                text: text,
                textSub: textSub,
                onTap: () => setState(() => _selected = WalletType.personal),
              ),
              const SizedBox(height: 12),

              // Group card
              Stack(
                children: [
                  _TypeCard(
                    selected: _selected == WalletType.group,
                    icon: Icons.group_outlined,
                    iconColor: purple,
                    iconBg: purple.withAlpha(34),
                    title: 'Akiba ya Kikundi',
                    description: 'Akiba ya pamoja na familia au marafiki. Kutoa pesa kunahitaji uthibitisho wa 80% ya wanachama.',
                    tags: const ['Wanachama wengi', 'Uamuzi wa pamoja', 'Uwazi'],
                    accentColor: purple,
                    accentLight: purpleLight,
                    borderColor: border,
                    surface: surface,
                    surfaceAlt: surfaceAlt,
                    text: text,
                    textSub: textSub,
                    onTap: () => setState(() => _selected = WalletType.group),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(8)),
                      child: const Text('MPYA', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                    ),
                  ),
                ],
              ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selected == null
                      ? null
                      : () {
                          final draft = WalletDraft(kind: _selected!);
                          Navigator.of(context).pushNamed('/create/step1', arguments: draft);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selected == WalletType.group ? purple : AppColors.blue,
                    disabledBackgroundColor: const Color(0xFFCCCCCC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: _selected != null ? 4 : 0,
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

class _TypeCard extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String description;
  final List<String> tags;
  final Color accentColor;
  final Color accentLight;
  final Color borderColor;
  final Color surface;
  final Color surfaceAlt;
  final Color text;
  final Color textSub;
  final VoidCallback onTap;

  const _TypeCard({
    required this.selected,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.description,
    required this.tags,
    required this.accentColor,
    required this.accentLight,
    required this.borderColor,
    required this.surface,
    required this.surfaceAlt,
    required this.text,
    required this.textSub,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? accentLight : surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? accentColor : borderColor, width: 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, size: 24, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: text)),
                      if (selected) Icon(Icons.check_circle_rounded, size: 20, color: accentColor),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: TextStyle(fontSize: 12, color: textSub, height: 1.5)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: tags.map((t) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: surfaceAlt, borderRadius: BorderRadius.circular(10)),
                      child: Text(t, style: TextStyle(fontSize: 10, color: textSub, fontWeight: FontWeight.w600)),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
