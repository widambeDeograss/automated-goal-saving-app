import 'package:flutter/material.dart';
import '../models/wallet.dart';
import '../models/group_models.dart';
import '../theme/tokens.dart';
import '../widgets/avatar.dart';
import '../widgets/step_dots.dart';

class CreateGroupMembersScreen extends StatefulWidget {
  final WalletDraft draft;
  const CreateGroupMembersScreen({super.key, required this.draft});

  @override
  State<CreateGroupMembersScreen> createState() => _CreateGroupMembersScreenState();
}

class _CreateGroupMembersScreenState extends State<CreateGroupMembersScreen> {
  late WalletDraft _draft;
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  static const _meId = 1;
  static const _meName = 'Mimi';
  static const _mePhone = '+255 754 100 100';
  static const _meInitials = 'M';

  static const _colors = [
    Color(0xFF3AABDF), Color(0xFFF6A800), Color(0xFF22C55E),
    Color(0xFFEF4444), Color(0xFF8B5CF6), Color(0xFFEC4899),
    Color(0xFF14B8A6), Color(0xFFF59E0B),
  ];

  @override
  void initState() {
    super.initState();
    _draft = widget.draft;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  String _initialsOf(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts.take(2).map((w) => w[0].toUpperCase()).join();
  }

  bool get _canAdd {
    final phone = _phoneCtrl.text.trim();
    final name = _nameCtrl.text.trim();
    return name.length >= 2 && RegExp(r'^[+]?[\d\s]{7,}$').hasMatch(phone);
  }

  void _add() {
    if (!_canAdd) return;
    final newMember = GroupMember(
      id: DateTime.now().millisecondsSinceEpoch,
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      initials: _initialsOf(_nameCtrl.text),
      color: _colors[_draft.members.length % _colors.length],
      role: MemberRole.member,
      status: MemberStatus.pending,
    );
    setState(() {
      _draft.members = [..._draft.members, newMember];
      _nameCtrl.clear();
      _phoneCtrl.clear();
    });
  }

  void _remove(int id) => setState(() => _draft.members = _draft.members.where((m) => m.id != id).toList());

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

    final canProceed = _draft.members.isNotEmpty;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(padding: const EdgeInsets.all(4), child: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: textSub)),
                      ),
                      Text('Ongeza Wanachama', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text)),
                      const SizedBox(width: 28),
                    ],
                  ),
                  StepDots(total: 4, current: 3),
                  Text('Wanachama wa Kikundi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: text)),
                  const SizedBox(height: 4),
                  Text('Ongeza watu unaowaamini. Watapokea ujumbe wa mwaliko.', style: TextStyle(fontSize: 13, color: textSub, height: 1.5)),
                  const SizedBox(height: 20),

                  // Creator (Me)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: purpleLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: purple.withAlpha(51)),
                    ),
                    child: Row(
                      children: [
                        Avatar(initials: _meInitials, color: purple, size: 36),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(_meName, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: text)),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                                    child: Text('MWANZILISHI', style: TextStyle(fontSize: 9, color: purple, fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              ),
                              Text(_mePhone, style: TextStyle(fontSize: 11, color: textSub)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Member list
                  ..._draft.members.map((m) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: shadow, blurRadius: 12, offset: const Offset(0, 2))],
                    ),
                    child: Row(
                      children: [
                        Avatar(initials: m.initials, color: m.color, size: 36),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: text), overflow: TextOverflow.ellipsis),
                              Text(m.phone, style: TextStyle(fontSize: 11, color: textSub)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.orangeLight, borderRadius: BorderRadius.circular(10)),
                          child: Text('Itakaribishwa', style: TextStyle(fontSize: 10, color: AppColors.orange, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _remove(m.id),
                          child: Padding(padding: const EdgeInsets.all(4), child: Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.danger)),
                        ),
                      ],
                    ),
                  )),

                  // Add form
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: border, width: 1.5, style: BorderStyle.solid),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person_add_outlined, size: 14, color: purple),
                            const SizedBox(width: 6),
                            Text('ONGEZA MWANACHAMA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSub, letterSpacing: 0.5)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _nameCtrl,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Jina la mwanachama',
                            hintStyle: TextStyle(color: textMuted, fontSize: 13),
                            filled: true,
                            fillColor: bg,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: border)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: border)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: purple)),
                          ),
                          style: TextStyle(color: text, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _phoneCtrl,
                          onChanged: (_) => setState(() {}),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Nambari ya simu (mf. +255 754 123 456)',
                            hintStyle: TextStyle(color: textMuted, fontSize: 13),
                            filled: true,
                            fillColor: bg,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: border)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: border)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: purple)),
                          ),
                          style: TextStyle(color: text, fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _canAdd ? _add : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _canAdd ? purple : (isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt),
                              disabledBackgroundColor: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt,
                              foregroundColor: _canAdd ? Colors.white : textMuted,
                              disabledForegroundColor: textMuted,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            child: const Text('+ Ongeza', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (_draft.members.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: purpleLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: purple.withAlpha(51)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline_rounded, size: 16, color: purple),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text('Ongeza angalau mwanachama mmoja. Wanachama wote watapokea mwaliko na lazima wakubali kabla ya kujiunga.', style: TextStyle(fontSize: 12, color: purple, height: 1.5)),
                          ),
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
                      ? () => Navigator.of(context).pushNamed('/create/confirm', arguments: _draft)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canProceed ? purple : const Color(0xFFCCCCCC),
                    disabledBackgroundColor: const Color(0xFFCCCCCC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: canProceed ? 4 : 0,
                    shadowColor: purple.withAlpha(85),
                  ),
                  child: Text(
                    'Endelea (${_draft.members.length + 1} wanachama)',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
