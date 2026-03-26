import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';

class ListingConditionChips extends StatelessWidget {
  const ListingConditionChips({
    super.key,
    required this.conditions,
    required this.selected,
    required this.onSelected,
  });

  final List<String> conditions;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Wrap(
      spacing: AppSizes.paddingXS,
      runSpacing: AppSizes.paddingXS,
      children:
          conditions.map((condition) {
            final isSelected = condition == selected;
            return GestureDetector(
              onTap: () => onSelected(condition),
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingM,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? colors.mainColor : colors.greyFillButton,
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  border: Border.all(
                    color: isSelected ? colors.mainColor : colors.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      condition,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTypography.body14Regular.copyWith(
                        color: isSelected ? colors.surface : colors.neutral,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
