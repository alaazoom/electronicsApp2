import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../configs/theme/app_typography.dart';
import '../../../../../configs/theme/app_colors.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_sizes.dart';

class NoListings extends StatelessWidget {
  final String text;

  const NoListings({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.noListing,
            width: 94,
            height: 120,
            fit: BoxFit.cover,
          ),
          const Gap(AppSizes.paddingM),
          Text(
            'No Listings Yet',
            style: AppTypography.body16Medium.copyWith(
              color: context.colors.titles,
            ),
          ),
          const Gap(AppSizes.paddingXS),
          Text(
            'You $text listings to display it yet.',
            textAlign: TextAlign.center,
            style: AppTypography.label12Regular.copyWith(
              color: context.colors.titles,
            ),
          ),
          const Gap(AppSizes.paddingL),
          ElevatedButton(
            onPressed: () {
              // Navigate to add listing page
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingXXL),
              child: Text('Add Listing'),
            ),
          ),
        ],
      ),
    );
  }
}
