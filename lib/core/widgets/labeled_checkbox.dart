import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.showRequiredStar = false,
    this.labelStyle,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;
  final bool showRequiredStar;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: Text(
            label,
            style:
                labelStyle ??
                AppTypography.body14Regular.copyWith(color: colors.text),
          ),
        ),
        if (showRequiredStar) ...[
          Text(
            '*',
            style: AppTypography.body14Regular.copyWith(color: colors.error),
          ),
        ],
      ],
    );
  }
}
