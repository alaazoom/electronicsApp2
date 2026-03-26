import 'package:flutter/material.dart';
import '../../../../home/presentation/widgets/listings_grid_view.dart';
import '../../../../products/data/models/product_model.dart';
import 'empty_listings_section.dart';

class ProfileListingsSection extends StatelessWidget {
  final List<ProductModel> listings;

  const ProfileListingsSection({super.key, required this.listings});

  @override
  Widget build(BuildContext context) {
    if (listings.isEmpty) {
      return const EmptyListingsSection();
    }
    return ListingsGridView(
      listings: listings,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }
}
