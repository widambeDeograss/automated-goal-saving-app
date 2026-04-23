import 'package:flutter/material.dart';

class InfoBanner extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;
  final IconData icon;

  const InfoBanner({
    super.key,
    required this.text,
    required this.bgColor,
    required this.textColor,
    this.icon = Icons.info_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 12, color: textColor, height: 1.5)),
          ),
        ],
      ),
    );
  }
}
