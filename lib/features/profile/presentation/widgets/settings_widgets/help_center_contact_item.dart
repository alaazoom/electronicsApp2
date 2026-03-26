import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';

class HelpCenterContactItem extends StatelessWidget {
  const HelpCenterContactItem({
    super.key,
    required this.svgPath,
    required this.title,
    required this.onTap,
    required this.context,
  });

  final String svgPath;
  final String title;
  final VoidCallback onTap;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.background,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          boxShadow: [
            BoxShadow(
              color: context.colors.border,
              blurRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(AppSizes.paddingS),
          onTap: onTap,
          leading: Container(
            decoration: BoxDecoration(
              color: context.colors.mainColor.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingXS),
              child: SvgPicture.asset(
                height: 40,
                width: 40,
                svgPath,
                color: context.colors.mainColor,
              ),
            ),
          ),
          title: Text(
            title,
            style: AppTypography.body16Regular.copyWith(
              color: context.colors.titles,
            ),
          ),
        ),
      ),
    );
  }
}
