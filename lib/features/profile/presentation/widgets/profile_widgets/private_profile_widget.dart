import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_routes.dart';
import 'package:second_hand_electronics_marketplace/features/profile/presentation/widgets/profile_widgets/profile_listing_section.dart';
import 'package:second_hand_electronics_marketplace/features/profile/presentation/widgets/profile_widgets/trust_indicators_section.dart';
import '../../../../../configs/theme/app_colors.dart';
import '../../../../../configs/theme/app_typography.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../auth/data/models/auth_models.dart';
import '../../../../products/data/models/product_model.dart';

class PrivateProfileWidget extends StatelessWidget {
  const PrivateProfileWidget({
    super.key,
    required this.userListings,
    required this.user,
  });

  final UserModel user;
  final List<ProductModel> userListings;

  @override
  Widget build(BuildContext context) {
    final isFullyVerified =
        user.isEmailVerified && user.isPhoneVerified && user.isIdentityVerified;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.colors.background,
            borderRadius: BorderRadius.circular(AppSizes.borderRadius10),
            border: Border.all(color: context.colors.border, width: 0.3),
            boxShadow: [
              BoxShadow(
                color: context.colors.border,
                blurRadius: 4,
                spreadRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingXS),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trust Indicators',
                  style: AppTypography.body16Medium.copyWith(
                    color: context.colors.titles,
                  ),
                ),
                if (!isFullyVerified) ...[
                  const SizedBox(height: AppSizes.paddingXS),
                  Text(
                    'Verify your identity, mobile and email to get “Verified” badge. Tap to verify missing items',
                    style: AppTypography.body14Regular.copyWith(
                      color: context.colors.neutral,
                    ),
                  ),
                ],
                const SizedBox(height: AppSizes.paddingXS),
                TrustIndicatorsSection(user: user),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSizes.paddingM),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Listings',
              style: AppTypography.body16Medium.copyWith(
                color: context.colors.titles,
              ),
            ),
            InkWell(
              onTap: () {
                context.pushNamed(AppRoutes.mylistings);
              },
              child: Text(
                'See All',
                style: AppTypography.label12Regular.copyWith(
                  color: context.colors.titles,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingM),
        //   const EmptyListingsSection(),
        ProfileListingsSection(listings: userListings),
      ],
    );
  }
}
