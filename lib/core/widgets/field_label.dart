import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel({
    super.key,
    required this.label,
    this.isRequired = false,
    this.style,
    this.requiredColor,
  });

  final String label;
  final bool isRequired;
  final TextStyle? style;
  final Color? requiredColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Text(
          label,
          style:
              style ??
              AppTypography.body14Regular.copyWith(color: colors.titles),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          Text(
            '*',
            style: AppTypography.body14Regular.copyWith(
              color: requiredColor ?? colors.error,
            ),
          ),
        ],
      ],
    );
  }
}
