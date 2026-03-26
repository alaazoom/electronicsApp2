import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_assets.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_routes.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            children: [
              const Spacer(),
              SvgPicture.asset(
                AppAssets.noInternetSvg,
                width: 120,
                height: 120,
              ),
              const SizedBox(height: AppSizes.paddingL),
              Text(
                'No Internet Connection',
                style: AppTypography.h3_18Medium.copyWith(color: colors.titles),
              ),
              const SizedBox(height: AppSizes.paddingXS),
              Text(
                'It looks like you\'re offline. Your changes are saved locally and will be uploaded once you\'re back online.',
                textAlign: TextAlign.center,
                style: AppTypography.body14Regular.copyWith(color: colors.hint),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Try again'),
                ),
              ),
              const SizedBox(height: AppSizes.paddingM),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.goNamed(AppRoutes.addListing),
                  child: const Text('Continue editing'),
                ),
              ),
              const SizedBox(height: AppSizes.paddingL),
            ],
          ),
        ),
      ),
    );
  }
}
