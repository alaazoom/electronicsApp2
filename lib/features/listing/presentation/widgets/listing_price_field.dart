import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/field_label.dart';

class ListingPriceField extends StatelessWidget {
  const ListingPriceField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.label = 'Price',
    this.currency = 'ILS',
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String label;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label: label, isRequired: true),
        const SizedBox(height: AppSizes.paddingXS),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
          ],
          onChanged: onChanged,
          style: AppTypography.body16Regular.copyWith(color: colors.text),
          decoration: InputDecoration(
            hintText: 'Enter price (e.g. 250)',
            suffixText: currency,
          ),
        ),
        const SizedBox(height: AppSizes.paddingXS),
        Text(
          'Set a competitive price',
          style: AppTypography.label12Regular.copyWith(color: colors.hint),
        ),
      ],
    );
  }
}
