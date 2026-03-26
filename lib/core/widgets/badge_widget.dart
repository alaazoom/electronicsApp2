import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';

class BadgeWidget extends StatelessWidget {
  BadgeWidget({super.key, required this.text, this.bgColor, this.textColor});

  final String text;
  Color? bgColor;
  Color? textColor;

  @override
  Widget build(BuildContext context) {
    bgColor = bgColor ?? context.colors.neutralWithoutTransparent;
    textColor = textColor ?? context.colors.neutral;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingS,
        vertical: AppSizes.paddingXXS,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.paddingXS),
      ),
      child: Text(
        text,
        style: AppTypography.label12Regular.copyWith(color: textColor),
      ),
    );
  }
}
