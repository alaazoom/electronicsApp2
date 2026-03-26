import 'package:flutter/material.dart';
import '../../../../../../configs/theme/theme_exports.dart';
import '../../../../../../core/constants/constants_exports.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.borderRadius10),
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingXS),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTypography.body14Regular.copyWith(
                  color: colors.titles,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => onChanged(!value),
              child: SvgPicture.asset(
                value ? AppAssets.onSvg : AppAssets.offSvg,
                width: 30,
                height: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
