import 'package:flutter/material.dart';
import '../theme/tokens.dart';

enum NavTab { home, send, savings, payments, services }

class BottomNav extends StatelessWidget {
  final NavTab active;
  final ValueChanged<NavTab> onTap;

  const BottomNav({super.key, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark ? AppColors.darkNav : AppColors.lightNav;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return Container(
      decoration: BoxDecoration(
        color: navBg,
        border: Border(top: BorderSide(color: border, width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
      child: Row(
        children: [
          _NavItem(tab: NavTab.home, label: 'Nyumbani', icon: Icons.home_outlined, active: active, onTap: onTap, muted: muted),
          _NavItem(tab: NavTab.send, label: 'Tuma Pesa', icon: Icons.swap_horiz_rounded, active: active, onTap: onTap, muted: muted),
          _FabItem(onTap: () => onTap(NavTab.savings)),
          _NavItem(tab: NavTab.payments, label: 'Malipo', icon: Icons.bar_chart_rounded, active: active, onTap: onTap, muted: muted),
          _NavItem(tab: NavTab.services, label: 'Huduma', icon: Icons.star_outline_rounded, active: active, onTap: onTap, muted: muted),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final NavTab tab;
  final String label;
  final IconData icon;
  final NavTab active;
  final ValueChanged<NavTab> onTap;
  final Color muted;

  const _NavItem({
    required this.tab,
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = tab == active;
    final color = isActive ? AppColors.orange : muted;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(tab),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}

class _FabItem extends StatelessWidget {
  final VoidCallback onTap;
  const _FabItem({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: const Offset(0, -12),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: AppColors.orange.withAlpha(85), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
