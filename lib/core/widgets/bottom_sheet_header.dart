import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_assets.dart';

class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({
    super.key,
    required this.title,
    required this.onClose,
    this.leading,
    this.leadingSpacing = 0,
    this.titleStyle,
  });

  final String title;
  final VoidCallback onClose;
  final Widget? leading;
  final double leadingSpacing;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        if (leading != null) ...[
          leading!,
          if (leadingSpacing > 0) SizedBox(width: leadingSpacing),
        ],
        Expanded(
          child: Text(
            title,
            style:
                titleStyle ??
                AppTypography.h3_18Medium.copyWith(color: colors.titles),
          ),
        ),
        IconButton(
          onPressed: onClose,
          icon: SvgPicture.asset(
            AppAssets.closeSquareIcon,
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }
}
