import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/field_label.dart';

class ListingSelectField extends StatelessWidget {
  const ListingSelectField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.isRequired = false,
    this.helperText,
    this.placeholder,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final bool isRequired;
  final String? helperText;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final String placeholderText = placeholder ?? 'Select $label';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label: label, isRequired: isRequired),
        const SizedBox(height: AppSizes.paddingXS),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingM,
              vertical: AppSizes.paddingS,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value.isEmpty ? placeholderText : value,
                    style: AppTypography.body16Regular.copyWith(
                      color: value.isEmpty ? colors.hint : colors.text,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: colors.hint),
              ],
            ),
          ),
        ),
        if (helperText != null && helperText!.isNotEmpty) ...[
          const SizedBox(height: AppSizes.paddingXS),
          Text(
            helperText!,
            style: AppTypography.label12Regular.copyWith(color: colors.hint),
          ),
        ],
      ],
    );
  }
}
