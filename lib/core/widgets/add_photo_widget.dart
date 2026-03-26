import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';

class AddPhotoWidget extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback? onTap;

  const AddPhotoWidget({
    super.key,
    required this.iconPath,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(color: colors.border),
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 36.0,
              height: 36.0,
              decoration: BoxDecoration(
                color: colors.mainColor10,
                shape: BoxShape.circle,
              ),

              alignment: Alignment.center,
              child: SvgPicture.asset(iconPath),
            ),

            const SizedBox(width: 14.0),
            Expanded(
              child: Text(
                title,
                style: AppTypography.body16Regular.copyWith(color: colors.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
