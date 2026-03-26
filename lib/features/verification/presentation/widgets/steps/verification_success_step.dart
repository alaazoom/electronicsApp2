import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import '../../../../../core/widgets/status_feedback_widget.dart';

class VerificationSuccessStep extends StatelessWidget {
  const VerificationSuccessStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StatusFeedbackWidget(
            iconPath: AppAssets.popupDone,
            title: AppStrings.successStepTitle,
            description: AppStrings.successStepDescription,
            height: 113,
          ),
          SizedBox(height: AppSizes.padding2XL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: Text(AppStrings.goToProfile),
            ),
          ),
        ],
      ),
    );
  }
}
