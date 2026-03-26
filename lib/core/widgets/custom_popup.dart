import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';

class CustomPopup {
  static void show(
    BuildContext context, {
    required Widget body,
    required String primaryButtonText,
    required VoidCallback onPrimaryButtonPressed,
    String? secondaryButtonText,
    VoidCallback? onSecondaryButtonPressed,
    Color? primaryButtonColor,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSizes.paddingL,
              horizontal: AppSizes.paddingM,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                body,

                const SizedBox(height: AppSizes.paddingL),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: onPrimaryButtonPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryButtonColor,
                    ),

                    child: Text(primaryButtonText),
                  ),
                ),

                if (secondaryButtonText != null) ...[
                  const SizedBox(height: AppSizes.paddingM),
                  SizedBox(
                    width: double.infinity,

                    child: OutlinedButton(
                      onPressed:
                          onSecondaryButtonPressed ??
                          () => Navigator.pop(context),
                      child: Text(secondaryButtonText),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
