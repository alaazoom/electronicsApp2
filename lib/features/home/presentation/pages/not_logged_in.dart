import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_routes.dart';

import '../../../../configs/theme/app_typography.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/status_feedback_widget.dart';

class NotLoggedInScreen extends StatelessWidget {
  const NotLoggedInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StatusFeedbackWidget(
              iconPath: AppAssets.popupWarning,
              title: 'You Need to be Logged In',
              description: 'Sign Up or Login to view your profile',
            ),
            SizedBox(height: AppSizes.paddingL),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.pushNamed(AppRoutes.login);
                },
                child: Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
