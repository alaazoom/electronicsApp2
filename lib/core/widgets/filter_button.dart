import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_assets.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/my_listings_widgets/filter_model.dart';

class FilterButton extends StatelessWidget {
  final VoidCallback? onTap;
  const FilterButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              isScrollControlled: true,
              builder: (_) => FilterModel(),
            );
          },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.colors.surface,
          border: Border.all(color: context.colors.border),
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        child: SvgPicture.asset(
          AppAssets.filterSvg,
          width: 16,
          height: 16,
          colorFilter: ColorFilter.mode(context.colors.icons, BlendMode.srcIn),
        ),
      ),
    );
  }
}
