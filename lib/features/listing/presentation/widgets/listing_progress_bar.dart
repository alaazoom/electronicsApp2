import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/verification_steps.dart';

class ListingProgressBar extends StatelessWidget {
  const ListingProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return StepsProgressBar(
      current: currentStep,
      total: totalSteps,
      padding: EdgeInsets.zero,
      labelStyle: AppTypography.body14Regular.copyWith(
        color: context.colors.hint,
      ),
    );
  }
}
