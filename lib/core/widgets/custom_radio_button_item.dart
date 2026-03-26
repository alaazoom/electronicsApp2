import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';

/// A reusable custom radio button item widget.
///
/// This widget displays a selectable item with a label and a radio button indicator.
/// It can be used in various contexts like country selection, ID type selection, etc.
class CustomRadioButtonItem extends StatelessWidget {
  /// The label text to display
  final String label;

  /// Whether this item is currently selected
  final bool isSelected;

  /// Callback function when the item is tapped
  final VoidCallback onTap;

  const CustomRadioButtonItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM,
          vertical: AppSizes.paddingS,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          border: Border.all(
            color:
                isSelected ? context.colors.mainColor : context.colors.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTypography.body16Regular.copyWith(
                  color: isSelected ? context.colors.text : context.colors.hint,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected
                          ? context.colors.mainColor
                          : context.colors.placeholders,
                  width: 1.5,
                ),
              ),
              child:
                  isSelected
                      ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: context.colors.mainColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
