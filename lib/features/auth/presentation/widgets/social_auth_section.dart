import 'package:flutter/material.dart';
import '../../../../configs/theme/theme_exports.dart';
import '../../../../core/constants/constants_exports.dart';
import '../../../../core/widgets/social_media_button.dart';

class SocialAuthSection extends StatelessWidget {
  const SocialAuthSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: context.colors.hint)),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingXS,
              ),
              child: Text(
                AppStrings.orContinueWith,
                style: AppTypography.label12Regular.copyWith(
                  color: context.colors.hint,
                ),
              ),
            ),
            Expanded(child: Divider(color: context.colors.hint)),
          ],
        ),
        const SizedBox(height: AppSizes.paddingS),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: SocialMediaButton(iconPath: AppAssets.googleIcon)),
            const SizedBox(width: AppSizes.paddingM),
            Expanded(child: SocialMediaButton(iconPath: AppAssets.appleIcon)),
            const SizedBox(width: AppSizes.paddingM),
            Expanded(
              child: SocialMediaButton(iconPath: AppAssets.facebookIcon),
            ),
          ],
        ),
      ],
    );
  }
}
