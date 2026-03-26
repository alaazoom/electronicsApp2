import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/horizontal_card.dart';
import 'package:second_hand_electronics_marketplace/features/products/data/models/product_model.dart';

class ListingsListView extends StatelessWidget {
  final List<ProductModel> listings;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const ListingsListView({
    super.key,
    required this.listings,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      clipBehavior: Clip.none,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: listings.length,
      padding: EdgeInsets.zero,
      separatorBuilder: (c, i) => const SizedBox(height: AppSizes.paddingS),
      itemBuilder: (context, index) {
        return HorizontalCard(listing: listings[index]);
      },
    );
  }
}
