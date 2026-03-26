import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_assets.dart';

import '../../../../../core/constants/app_sizes.dart';

class TrustIndicatorCard extends StatelessWidget {
  const TrustIndicatorCard({
    super.key,
    required this.label,
    required this.iconSvgPath,
    required this.verified,
    this.width = 114.33,
    this.height = 90,
    this.iconSize = 20,
    this.badgeSize = 24,
    this.onTap,
  });

  final String label;
  final String iconSvgPath;
  final bool verified;
  final double width;
  final double height;
  final double iconSize;
  final double badgeSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    Widget cardContent = Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border, width: 1),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius10),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingXS10,
            vertical: AppSizes.paddingS,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colors.mainColor.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingXS),
                  child: SvgPicture.asset(
                    iconSvgPath,
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.paddingS),
              Text(
                label,
                style: AppTypography.label12Regular.copyWith(
                  color: colors.text,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );

    if (!verified) {
      cardContent = Opacity(opacity: 0.4, child: cardContent);
    }

    if (onTap != null) {
      cardContent = Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius10),
          onTap: onTap,
          child: cardContent,
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        cardContent,
        if (verified)
          Positioned(
            top: -8,
            right: -5,
            child: SvgPicture.asset(
              AppAssets.verifiedSvg,
              colorFilter: ColorFilter.mode(
                context.colors.success,
                BlendMode.srcIn,
              ),
              width: badgeSize,
              height: badgeSize,
            ),
          ),
      ],
    );
  }
}
