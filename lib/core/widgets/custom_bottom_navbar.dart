import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_shadows.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddTap,
  });

  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingS),
      decoration: BoxDecoration(
        color: context.colors.surface,
        boxShadow: context.shadows.bottomSheet,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(
            context: context,
            index: 0,
            activeIconPath: AppAssets.homeFilledIcon,
            inactiveIconPath: AppAssets.homeOutlineIcon,
            label: AppStrings.home,
            isSelected: currentIndex == 0,
          ),

          _buildNavItem(
            context: context,
            index: 1,
            activeIconPath: AppAssets.categoryColoredIcon,
            inactiveIconPath: AppAssets.categoryUnColoredIcon,
            label: AppStrings.categories,
            isSelected: currentIndex == 1,
          ),
          SizedBox(width: 10),
          _buildCenterButton(context: context),
          SizedBox(width: 10),

          _buildNavItem(
            context: context,
            index: 2,
            activeIconPath: AppAssets.chatFilledIcon,
            inactiveIconPath: AppAssets.chatOutlineIcon,
            label: AppStrings.chat,
            isSelected: currentIndex == 2,
          ),

          _buildNavItem(
            context: context,
            index: 3,
            activeIconPath: AppAssets.profileFilledIcon,
            inactiveIconPath: AppAssets.profileOutlineIcon,
            label: AppStrings.profile,
            isSelected: currentIndex == 3,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String activeIconPath,
    required String inactiveIconPath,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        height: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(isSelected ? activeIconPath : inactiveIconPath),

            if (isSelected) ...[
              const SizedBox(height: AppSizes.paddingXS),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: AppTypography.label12Medium.copyWith(
                    color: context.colors.mainColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton({required BuildContext context}) {
    return GestureDetector(
      onTap: onAddTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color: context.colors.mainColor,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(AppAssets.fabPlusIcon),
      ),
    );
  }
}
