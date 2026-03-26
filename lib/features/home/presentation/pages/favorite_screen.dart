import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/status_feedback_widget.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/vertical_card.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/horizontal_card.dart';
import 'package:second_hand_electronics_marketplace/features/wishlist/presentation/cubits/wishlist_cubit.dart';
import 'package:second_hand_electronics_marketplace/features/wishlist/presentation/cubits/wishlist_state.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/my_listings_widgets/sort_model.dart';
import 'package:second_hand_electronics_marketplace/features/home/presentation/widgets/search_with_filter.dart';
import 'package:second_hand_electronics_marketplace/features/products/data/models/product_model.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool isGridView = true;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.favorite),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WishlistSuccess) {
            List<ProductModel> products = state.wishlistItems;

            if (searchQuery.isNotEmpty) {
              products =
                  products
                      .where(
                        (p) => p.title.toLowerCase().contains(
                          searchQuery.toLowerCase(),
                        ),
                      )
                      .toList();
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  child: Column(
                    children: [
                      SearchWithFilterWidget(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        onFilterTap: () {
                          // TODO: Implement filter logic
                        },
                      ),
                      const Gap(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SortModel(),
                              const Gap(4),
                              const Text(AppStrings.sort),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed:
                                    () => setState(() => isGridView = false),
                                icon: SvgPicture.asset(
                                  'assets/svgs/document_colord.svg',
                                  colorFilter: ColorFilter.mode(
                                    !isGridView
                                        ? context.colors.mainColor
                                        : context.colors.icons,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed:
                                    () => setState(() => isGridView = true),
                                icon: SvgPicture.asset(
                                  'assets/svgs/category_uncolord.svg',
                                  colorFilter: ColorFilter.mode(
                                    isGridView
                                        ? context.colors.mainColor
                                        : context.colors.icons,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child:
                      products.isEmpty
                          ? _buildEmptyState(
                            context,
                            isSearch: searchQuery.isNotEmpty,
                          )
                          : isGridView
                          ? GridView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingM,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.60,
                                ),
                            itemCount: products.length,
                            itemBuilder:
                                (context, index) =>
                                    VerticalCard(listing: products[index]),
                          )
                          : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingM,
                            ),
                            itemCount: products.length,
                            separatorBuilder: (_, __) => const Gap(12),
                            itemBuilder:
                                (context, index) =>
                                    HorizontalCard(listing: products[index]),
                          ),
                ),
              ],
            );
          }

          if (state is WishlistFailure) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }

          return _buildEmptyState(context);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, {bool isSearch = false}) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StatusFeedbackWidget(
              iconPath: AppAssets.favoriteSvg,
              title: isSearch ? 'No items found' : 'Save your favorites',
              description:
                  isSearch
                      ? 'Try searching for something else'
                      : 'Favorites some items and find them here',
            ),
            if (!isSearch) ...[
              const SizedBox(height: AppSizes.paddingL),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Browse'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
