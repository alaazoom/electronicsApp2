import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/vertical_card.dart';
import 'package:second_hand_electronics_marketplace/features/products/data/models/product_model.dart';

class ListingsGridView extends StatelessWidget {
  final List<ProductModel> listings;
  final ScrollPhysics? physics; // عشان لو حطيتيها جوا سكرول تاني
  final bool shrinkWrap;

  const ListingsGridView({
    super.key,
    required this.listings,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      clipBehavior: Clip.none,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: listings.length,
      padding: EdgeInsets.zero, // التحكم بالبادينج يفضل يكون من الخارج
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSizes.paddingS,
        crossAxisSpacing: AppSizes.paddingS,
        childAspectRatio: 0.63,
      ),
      itemBuilder: (context, index) {
        return VerticalCard(listing: listings[index]);
      },
    );
  }
}
