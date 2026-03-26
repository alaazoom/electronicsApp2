import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';

class TopInRegistrationWidget extends StatelessWidget {
  const TopInRegistrationWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTypography.h3_18Medium.copyWith(color: colors.titles),
        ),
        const SizedBox(height: AppSizes.paddingXS),
        Text(
          subtitle,
          style: AppTypography.body14Regular.copyWith(color: colors.hint),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
