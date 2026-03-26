import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/card_content_widget.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/card_image_widget.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/badge_widget.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/favorite_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/wishlist/presentation/cubits/wishlist_cubit.dart';
import '../../features/wishlist/presentation/cubits/wishlist_state.dart';
import '../../features/products/data/models/product_model.dart';

import 'package:gap/gap.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/my_listings_widgets/more_vert_button.dart';

class HorizontalCard extends StatelessWidget {
  final ProductModel listing;
  final VoidCallback? onTap;
  final bool isOwnerMode;
  final int ownerMenuState;

  const HorizontalCard({
    super.key,
    required this.listing,
    this.onTap,
    this.isOwnerMode = false,
    this.ownerMenuState = 0,
  });

  @override
  Widget build(BuildContext context) {
    const double imageWidth = 120.0;
    const double favButtonSize = imageWidth / 4;
    return GestureDetector(
      onTap:
          onTap ??
          () => context.pushNamed(AppRoutes.productDetails, extra: listing),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          boxShadow: context.shadows.card,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          child: Row(
            children: [
              SizedBox(
                width: imageWidth,
                height: double.infinity,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned.fill(
                      child: CardImageWidget(
                        imageUrl:
                            listing.images.isNotEmpty
                                ? listing.images.first
                                : '',
                      ),
                    ),
                    if (!isOwnerMode)
                      Positioned(
                        top: AppSizes.paddingXS,
                        left: AppSizes.paddingXS,
                        child: BlocBuilder<WishlistCubit, WishlistState>(
                          builder: (context, state) {
                            final isFav = context
                                .read<WishlistCubit>()
                                .isFavorite(listing.id);
                            return FavoriteButton(
                              key: ValueKey('fav_${listing.id}'),
                              isFavorite: isFav,
                              size: favButtonSize,
                              onTap:
                                  () => context
                                      .read<WishlistCubit>()
                                      .toggleWishlist(listing.id),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingS),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: CardContentWidget(listing: listing)),
                          if (isOwnerMode)
                            MoreVertButton(selectState: ownerMenuState),
                        ],
                      ),
                      const SizedBox(height: AppSizes.paddingXS),
                      Row(
                        children: [
                          BadgeWidget(text: listing.condition),
                          if (isOwnerMode) ...[
                            const Gap(8),
                            BadgeWidget(
                              text:
                                  listing.status.isEmpty
                                      ? 'Pending'
                                      : listing.status[0].toUpperCase() +
                                          listing.status.substring(1),
                              bgColor: switch (listing.status.toLowerCase()) {
                                'active' => const Color.fromARGB(
                                  255,
                                  213,
                                  248,
                                  226,
                                ),
                                'pending' => const Color.fromARGB(
                                  255,
                                  253,
                                  244,
                                  209,
                                ),
                                'rejected' => const Color.fromARGB(
                                  255,
                                  238,
                                  219,
                                  219,
                                ),
                                _ => context.colors.neutralWithoutTransparent,
                              },
                              textColor: switch (listing.status.toLowerCase()) {
                                'active' => const Color(0XFF22C55E),
                                'pending' => const Color(0XFFFACC15),
                                'rejected' => const Color(0XFFEF4444),
                                _ => context.colors.neutral,
                              },
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
