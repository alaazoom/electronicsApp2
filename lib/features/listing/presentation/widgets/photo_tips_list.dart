import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';

/// Reusable widget showing a vertical list of photo tips.
class PhotoTipsList extends StatelessWidget {
  const PhotoTipsList({super.key, required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        for (int i = 0; i < tips.length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: colors.mainColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSizes.paddingXS),
              Expanded(
                child: Text(
                  tips[i],
                  style: AppTypography.body14Regular.copyWith(
                    color: colors.text,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.paddingM),
            ],
          ),
          if (i != tips.length - 1) const SizedBox(height: AppSizes.paddingM),
        ],
      ],
    );
  }
}
