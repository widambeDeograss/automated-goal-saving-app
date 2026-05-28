import 'package:flutter/material.dart';
import '../models/group_models.dart';

class AvatarStack extends StatelessWidget {
  final List<GroupMember> members;
  final int max;
  final double size;

  const AvatarStack({
    super.key,
    required this.members,
    this.max = 4,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    final shown = members.take(max).toList();
    final overflow = members.length - shown.length;
    final total = shown.length + (overflow > 0 ? 1 : 0);
    final stackWidth = size + (total - 1) * (size - 10);

    return SizedBox(
      width: stackWidth,
      height: size,
      child: Stack(
        children: [
          ...shown.asMap().entries.map((e) {
            final i = e.key;
            final m = e.value;
            return Positioned(
              left: i * (size - 10),
              child: _circle(m.initials, m.color),
            );
          }),
          if (overflow > 0)
            Positioned(
              left: shown.length * (size - 10),
              child: _circle('+$overflow', const Color(0xFF9CA3AF)),
            ),
        ],
      ),
    );
  }

  Widget _circle(String label, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 2, offset: Offset(0, 1))],
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: (size * 0.34).roundToDouble(), fontWeight: FontWeight.w700),
      ),
    );
  }
}
