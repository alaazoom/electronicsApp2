import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import 'package:second_hand_electronics_marketplace/features/verification/data/models/verification_content.dart';

class VerificationInstructionView extends StatelessWidget {
  final VerificationStepContent content;
  final VoidCallback onTakePicture;

  const VerificationInstructionView({
    super.key,
    required this.content,
    required this.onTakePicture,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(content.title, style: AppTypography.h3_18Medium),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            content.subtitle,
            style: AppTypography.body14Regular.copyWith(
              color: context.colors.neutral,
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),

          ...content.guidelines.map(
            (guide) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.paddingS),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("• ", style: AppTypography.body14Medium),
                  Expanded(
                    child: Text(guide, style: AppTypography.body14Regular),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTakePicture,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.mainColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppStrings.takePhoto,
                style: AppTypography.body16Medium.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),
        ],
      ),
    );
  }
}
