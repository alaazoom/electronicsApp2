import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';

class FAQWidget extends StatelessWidget {
  final String title;
  final String description;

  const FAQWidget({Key? key, required this.title, required this.description})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        boxShadow: context.shadows.card,
        /*  boxShadow: [
          BoxShadow(
            color: context.colors.border,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],*/
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXS),
        child: ExpansionTile(
          childrenPadding: const EdgeInsets.only(
            left: AppSizes.paddingM,
            right: AppSizes.paddingM,
            bottom: AppSizes.paddingM,
          ),
          collapsedShape: const Border(),
          shape: const Border(),
          title: Text(
            title,
            style: AppTypography.body16Medium.copyWith(color: colors.titles),
          ),

          iconColor: colors.hint,
          collapsedIconColor: colors.hint,
          children: [
            const Divider(thickness: 1, height: 1),
            const SizedBox(height: AppSizes.paddingS),
            Text(
              description,
              style: AppTypography.body14Regular.copyWith(color: colors.hint),
            ),
          ],
        ),
      ),
    );
  }
}
