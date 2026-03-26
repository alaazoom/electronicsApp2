import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({super.key, required this.progressValue});

  final double progressValue;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.borderRadius10),
      child: LinearProgressIndicator(
        value: progressValue,
        minHeight: 16,
        backgroundColor: context.colors.border,
        valueColor: AlwaysStoppedAnimation<Color>(context.colors.mainColor),
      ),
    );
  }
}
