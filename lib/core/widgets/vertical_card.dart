import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/card_content_widget.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/card_image_widget.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/badge_widget.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/favorite_button.dart';

// استيراد الـ ProductModel الجديد
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/wishlist/presentation/cubits/wishlist_cubit.dart';
import '../../features/wishlist/presentation/cubits/wishlist_state.dart';
import 'package:gap/gap.dart';
import '../../features/products/data/models/product_model.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/my_listings_widgets/more_vert_button.dart';

class VerticalCard extends StatelessWidget {
  final ProductModel listing;
  final VoidCallback? onTap;
  final double? width;
  final bool isOwnerMode;
  final int ownerMenuState;

  const VerticalCard({
    super.key,
    required this.listing,
    this.onTap,
    this.width,
    this.isOwnerMode = false,
    this.ownerMenuState = 0,
  });

  @override
  Widget build(BuildContext context) {
    final double favButtonSize = (width != null) ? (width! / 6) : 30.0;

    return GestureDetector(
      onTap:
          onTap ??
          () => context.pushNamed(AppRoutes.productDetails, extra: listing),
      child: Container(
        clipBehavior: Clip.none,
        width: width,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          boxShadow: context.shadows.card,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: CardImageWidget(
                      imageUrl:
                          listing.images.isNotEmpty ? listing.images.first : '',
                    ),
                  ),
                  Positioned(
                    bottom: AppSizes.paddingXS,
                    left: AppSizes.paddingXS,
                    child: BadgeWidget(text: listing.condition),
                  ),
                  Positioned(
                    top: AppSizes.paddingXS,
                    right: AppSizes.paddingXS,
                    child:
                        isOwnerMode
                            ? Container(
                              height: 33,
                              width: 33,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Center(
                                child: MoreVertButton(
                                  selectState: ownerMenuState,
                                ),
                              ),
                            )
                            : BlocBuilder<WishlistCubit, WishlistState>(
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingS,
                  vertical: AppSizes.paddingXXS,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardContentWidget(listing: listing),
                    if (isOwnerMode) ...[
                      const Gap(6),
                      BadgeWidget(
                        text:
                            listing.status.isEmpty
                                ? 'Pending'
                                : listing.status[0].toUpperCase() +
                                    listing.status.substring(1),
                        bgColor: switch (listing.status.toLowerCase()) {
                          'active' => const Color.fromARGB(255, 213, 248, 226),
                          'pending' => const Color.fromARGB(255, 253, 244, 209),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
