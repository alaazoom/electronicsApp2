import 'package:flutter/material.dart';
import '../../../../../../configs/theme/theme_exports.dart';
import '../../../../../../core/constants/constants_exports.dart';

class LanguageCurrencySelectionTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const LanguageCurrencySelectionTile({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.paddingS),
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.paddingS,
          horizontal: AppSizes.paddingM,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          border: Border.all(
            color: selected ? context.colors.mainColor : context.colors.border,
          ),
        ),
        child: Row(
          children: [
            Expanded(child: Text(title, style: AppTypography.body16Regular)),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? context.colors.mainColor : context.colors.icons,
            ),
          ],
        ),
      ),
    );
  }
}
