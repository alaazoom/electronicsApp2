import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import '../../features/products/data/models/product_model.dart';

class CardContentWidget extends StatelessWidget {
  const CardContentWidget({super.key, required this.listing});

  final ProductModel listing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          listing.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.body14Regular.copyWith(color: colors.titles),
        ),

        const SizedBox(height: AppSizes.paddingXS),

        Text(
          '${listing.price} ILS',
          style: AppTypography.body16Medium.copyWith(color: colors.mainColor),
        ),

        const SizedBox(height: AppSizes.paddingXS),
        Row(
          children: [
            SvgPicture.asset(AppAssets.locationOutlinedIcon),
            const SizedBox(width: AppSizes.paddingXXS),
            Expanded(
              child: Text(
                'Gaza',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.label12Regular.copyWith(
                  color: colors.text,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
