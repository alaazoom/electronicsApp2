import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    required this.onTap,
    required this.size,
    required this.iconPath,
    this.iconColor,
  });
  final VoidCallback? onTap;
  final double size;
  final String iconPath;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.colors.surface,
          boxShadow: context.shadows.card,
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          iconPath,
          width: size - size * 0.40,
          height: size - size * 0.40,
          colorFilter: ColorFilter.mode(
            iconColor ?? context.colors.icons,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
