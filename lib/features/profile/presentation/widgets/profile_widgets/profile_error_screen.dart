import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_assets.dart';
import '../../../../../configs/theme/app_colors.dart';
import '../../../../../configs/theme/app_typography.dart';
import '../../../../../core/constants/app_sizes.dart';

class ProfileErrorScreen extends StatelessWidget {
  final String? message;
  const ProfileErrorScreen({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingS),
              child: Icon(Icons.settings_rounded, color: context.colors.icons),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.paddingM,
          0,
          AppSizes.paddingM,
          AppSizes.paddingM,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppAssets.popupWarning, width: 150, height: 150),
            const SizedBox(height: AppSizes.paddingL),
            Text(
              'Something went wrong!',
              textAlign: TextAlign.center,
              style: AppTypography.h3_18Medium.copyWith(
                color: context.colors.titles,
              ),
            ),
            Text(
              message != null
                  ? message!
                  : 'We couldn’t load your profile information. Please check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: AppTypography.body16Regular.copyWith(
                color: context.colors.titles,
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: Text('Try Again'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
