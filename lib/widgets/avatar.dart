import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String initials;
  final Color color;
  final double size;
  final String? name;
  final bool showName;
  final double? fontSize;

  const Avatar({
    super.key,
    required this.initials,
    required this.color,
    this.size = 36,
    this.name,
    this.showName = false,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final fs = fontSize ?? (size * 0.4).roundToDouble();
    final circle = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(color: Color(0x26000000), blurRadius: 3, offset: Offset(0, 1))],
      ),
      alignment: Alignment.center,
      child: Text(initials, style: TextStyle(color: Colors.white, fontSize: fs, fontWeight: FontWeight.w700)),
    );

    if (!showName || name == null) return circle;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        circle,
        const SizedBox(width: 10),
        Text(name!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
