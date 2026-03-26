import 'package:flutter/material.dart';

import '../../../../../configs/theme/app_colors.dart';
import '../../../../../configs/theme/app_typography.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_sizes.dart';

class EmptyListingsSection extends StatelessWidget {
  const EmptyListingsSection();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          children: [
            Image.asset(
              AppAssets.noListing,
              width: 94,
              height: 120,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              'This user has no active listing',
              style: AppTypography.label12Regular.copyWith(
                color: context.colors.titles,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
