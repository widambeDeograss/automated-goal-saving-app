import 'package:flutter/material.dart';
import '../theme/tokens.dart';

class StepDots extends StatelessWidget {
  final int total;
  final int current;

  const StepDots({super.key, required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(total, (i) {
          final isActive = i <= current;
          final isCurrent = i == current;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isCurrent ? 20 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? AppColors.blue : borderColor,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}
