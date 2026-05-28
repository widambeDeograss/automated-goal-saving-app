import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/wallet_provider.dart';
import '../models/group_models.dart';
import '../theme/tokens.dart';
import '../widgets/avatar.dart';

class InvitationsInboxScreen extends StatelessWidget {
  const InvitationsInboxScreen({super.key});

  String _fmt(int n) => 'TZS ${n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textSub = isDark ? AppColors.darkTextSub : AppColors.lightTextSub;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final purple = isDark ? AppColors.purpleDark : AppColors.purple;
    final purpleLight = isDark ? AppColors.purpleDarkBg : AppColors.purpleLight;
    final shadow = isDark ? const Color(0x66000000) : const Color(0x14000000);

    return Consumer<WalletProvider>(
      builder: (context, provider, _) {
        final invitations = provider.invitations;

        return Scaffold(
          backgroundColor: bg,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(padding: const EdgeInsets.all(4), child: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: textSub)),
                      ),
                      Text('Mialiko', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text)),
                      const SizedBox(width: 28),
                    ],
                  ),
                ),
                Expanded(
                  child: invitations.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.mail_outline_rounded, size: 48, color: textMuted),
                              const SizedBox(height: 12),
                              Text('Hakuna mialiko', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: text)),
                              const SizedBox(height: 6),
                              Text('Mialiko mipya itaonekana hapa', style: TextStyle(fontSize: 12, color: textSub)),
                            ],
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            Text('Watu wamekualika kujiunga na akiba ya kikundi. Kagua maelezo na chagua kukubali au kukataa.', style: TextStyle(fontSize: 13, color: textSub, height: 1.5)),
                            const SizedBox(height: 16),
                            ...invitations.map((inv) => _InvitationCard(
                              invitation: inv,
                              surface: surface,
                              border: border,
                              text: text,
                              textSub: textSub,
                              purple: purple,
                              purpleLight: purpleLight,
                              shadow: shadow,
                              fmt: _fmt,
                              onAccept: () {
                                provider.acceptInvitation(inv.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('✅ Umekubali mwaliko wa ${inv.groupName}!'), backgroundColor: AppColors.success),
                                );
                              },
                              onReject: () {
                                provider.rejectInvitation(inv.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Umerejesha mwaliko wa ${inv.groupName}'), backgroundColor: AppColors.danger),
                                );
                              },
                            )),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InvitationCard extends StatelessWidget {
  final GroupInvitation invitation;
  final Color surface, border, text, textSub, purple, purpleLight, shadow;
  final String Function(int) fmt;
  final VoidCallback onAccept, onReject;

  const _InvitationCard({
    required this.invitation, required this.surface, required this.border,
    required this.text, required this.textSub, required this.purple,
    required this.purpleLight, required this.shadow,
    required this.fmt, required this.onAccept, required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: shadow, blurRadius: 12, offset: const Offset(0, 2))],
        border: Border.all(color: purple.withAlpha(34)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Avatar(initials: invitation.fromInitials, color: invitation.fromColor, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mwaliko kutoka', style: TextStyle(fontSize: 11, color: textSub)),
                    Text(invitation.fromName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: text)),
                    Text(invitation.invitedAt, style: TextStyle(fontSize: 11, color: textSub)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Group preview
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: purpleLight, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: Center(child: Text(invitation.groupEmoji, style: const TextStyle(fontSize: 22))),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(invitation.groupName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: text)),
                          Text('Akiba ya Kikundi', style: TextStyle(fontSize: 11, color: purple, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(color: purple.withAlpha(34), height: 1),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _StatCell(label: 'Lengo', value: fmt(invitation.goal), text: text, textSub: textSub),
                    _StatCell(label: 'Wanachama', value: '${invitation.memberCount} watu', text: text, textSub: textSub),
                    _StatCell(label: 'Kufunga', value: 'Miezi ${invitation.lockMonths}', text: text, textSub: textSub),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.danger),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Kataa', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    shadowColor: purple.withAlpha(85),
                  ),
                  child: const Text('Kubali Mwaliko', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label, value;
  final Color text, textSub;
  const _StatCell({required this.label, required this.value, required this.text, required this.textSub});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: TextStyle(fontSize: 9, color: textSub, letterSpacing: 0.5)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: text)),
      ],
    ),
  );
}
