import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/filter_button.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/search_widget.dart';

class SearchWithFilterWidget extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  const SearchWithFilterWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SearchWidget(
              controller: controller ?? TextEditingController(),
              onChanged: onChanged ?? (val) {},
            ),
          ),

          const SizedBox(width: AppSizes.paddingXS),
          AspectRatio(
            aspectRatio: 1.0,
            child: FilterButton(onTap: onFilterTap),
          ),
        ],
      ),
    );
  }
}
