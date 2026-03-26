import 'package:flutter/material.dart';
import '../../../../../../configs/theme/theme_exports.dart';
import '../../../../../../core/constants/constants_exports.dart';

class LanguageCurrencyDecoratedListTile extends StatelessWidget {
  final String title;
  final String trailingValue;
  final VoidCallback onTap;

  const LanguageCurrencyDecoratedListTile({
    required this.title,
    required this.trailingValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _tileDecoration(context),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          vertical: AppSizes.paddingXS,
          horizontal: AppSizes.paddingS,
        ),
        title: Text(
          title,
          style: AppTypography.body16Regular.copyWith(
            color: context.colors.text,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              trailingValue,
              style: AppTypography.body14Regular.copyWith(
                color: context.colors.hint,
              ),
            ),
            const SizedBox(width: AppSizes.paddingXS),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: onTap,
              icon: Icon(
                Icons.arrow_forward_ios,
                size: AppSizes.paddingL,
                color: context.colors.icons,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _tileDecoration(BuildContext context) {
    return BoxDecoration(
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
    );
  }
}
