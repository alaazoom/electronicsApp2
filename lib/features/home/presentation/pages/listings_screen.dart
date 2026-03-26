import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/horizontal_card.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/search_widget.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/vertical_card.dart';
import 'package:second_hand_electronics_marketplace/features/home/presentation/widgets/listings_grid_view.dart';
import 'package:second_hand_electronics_marketplace/features/home/presentation/widgets/listings_list_view.dart';
import 'package:second_hand_electronics_marketplace/features/home/presentation/widgets/search_with_filter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_hand_electronics_marketplace/features/products/presentation/cubit/products_cubit.dart';
import 'package:second_hand_electronics_marketplace/features/products/presentation/cubit/products_state.dart';
import 'package:second_hand_electronics_marketplace/features/products/data/models/product_model.dart';

class ListingsScreen extends StatefulWidget {
  final String title;
  final List<ProductModel> listings;

  const ListingsScreen({
    super.key,
    required this.title,
    required this.listings,
  });

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  bool isGridView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          children: [
            SearchWithFilterWidget(),

            const SizedBox(height: AppSizes.paddingM),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(AppAssets.swapIcon),
                    const SizedBox(width: 4),
                    Text(
                      AppStrings.sort,
                      style: AppTypography.body14Regular.copyWith(
                        color: context.colors.titles,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => isGridView = false),
                      child: SvgPicture.asset(
                        !isGridView
                            ? AppAssets.documentColoredIcon
                            : AppAssets.documentUnColoredIcon,
                      ),
                    ),
                    SizedBox(width: AppSizes.paddingXS),
                    GestureDetector(
                      onTap: () => setState(() => isGridView = true),
                      child: SvgPicture.asset(
                        isGridView
                            ? AppAssets.categoryColoredIcon
                            : AppAssets.categoryUnColoredIcon,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSizes.paddingM),

            Expanded(
              child: BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ProductsError) {
                    return Center(child: Text(state.message));
                  }

                  final products =
                      state is ProductsLoaded
                          ? state.products
                          : widget.listings;

                  if (products.isEmpty) {
                    return const Center(
                      child: Text('No products found for this category'),
                    );
                  }

                  return isGridView
                      ? ListingsGridView(listings: products)
                      : ListingsListView(listings: products);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
