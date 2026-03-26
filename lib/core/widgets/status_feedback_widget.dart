import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';

class StatusFeedbackWidget extends StatelessWidget {
  const StatusFeedbackWidget({
    super.key,
    required this.iconPath,
    required this.title,
    required this.description,
    this.width = 80,
    this.height = 80,
  });

  final String iconPath;
  final String title;
  final String description;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        SvgPicture.asset(iconPath, width: width, height: height),

        const SizedBox(height: AppSizes.paddingL),

        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTypography.h3_18Medium.copyWith(color: colors.titles),
        ),

        const SizedBox(height: AppSizes.paddingXS),

        Text(
          description,
          textAlign: TextAlign.center,
          style: AppTypography.body16Regular.copyWith(color: colors.hint),
        ),
      ],
    );
  }
}
