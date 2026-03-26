import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../../core/constants/constants_exports.dart';
import '../../../../../configs/theme/theme_exports.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final String icon;
  final Color iconColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final bool showArrow;

  const SettingsTile({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    this.textColor,
    this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: context.colors.border, width: 0.1),
        boxShadow: [
          BoxShadow(
            color: context.colors.border,
            blurRadius: 2,
            spreadRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          vertical: AppSizes.paddingXS,
          horizontal: AppSizes.paddingS,
        ),
        leading: SvgPicture.asset(
          icon,
          color: iconColor,
          height: 24,
          width: 24,
        ),
        title: Text(
          title,
          style: AppTypography.body16Regular.copyWith(
            color: textColor ?? context.colors.titles,
          ),
        ),
        trailing:
            showArrow
                ? Icon(
                  Icons.arrow_forward_ios,
                  size: AppSizes.paddingL,
                  color: context.colors.icons,
                )
                : null,
        onTap: onTap,
      ),
    );
  }
}
