import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';

class SocialMediaButton extends StatelessWidget {
  const SocialMediaButton({super.key, required this.iconPath});
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SvgPicture.asset(iconPath),
      padding: const EdgeInsets.all(18.5),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: context.colors.surface,
        boxShadow: context.shadows.card,
      ),
    );
  }
}
