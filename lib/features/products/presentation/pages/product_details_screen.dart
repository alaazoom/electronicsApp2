import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import 'package:second_hand_electronics_marketplace/features/products/data/models/product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: Stack(
        children: [
          // Content
          CustomScrollView(
            slivers: [
              // 1. Image Carousel
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    SizedBox(
                      height: screenWidth * 1.1,
                      width: double.infinity,
                      child:
                          product.images.isNotEmpty
                              ? PageView.builder(
                                itemCount: product.images.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentImageIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    product.images[index],
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (_, __, ___) => Container(
                                          color: Colors.grey[200],
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                          ),
                                        ),
                                  );
                                },
                              )
                              : Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.image, size: 100),
                              ),
                    ),
                    // Indicator Dots
                    if (product.images.length > 1)
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            product.images.length,
                            (index) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    _currentImageIndex == index
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // 2. Info Section
              SliverPadding(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Stats Row
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: context.colors.icons,
                        ),
                        const Gap(5),
                        Text(
                          _getTimeAgo(product.createdAt),
                          style: AppTypography.label12Regular.copyWith(
                            color: context.colors.text,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.visibility_outlined,
                          size: 16,
                          color: context.colors.icons,
                        ),
                        const Gap(5),
                        Text(
                          product.viewCount.toString(),
                          style: AppTypography.label12Regular.copyWith(
                            color: context.colors.text,
                          ),
                        ),
                        const Gap(15),
                        Icon(
                          Icons.favorite_border,
                          size: 16,
                          color: context.colors.icons,
                        ),
                        const Gap(5),
                        Text(
                          "20", // Placeholder for favorite count
                          style: AppTypography.label12Regular.copyWith(
                            color: context.colors.text,
                          ),
                        ),
                      ],
                    ),
                    const Gap(15),

                    // Title
                    Text(
                      product.title,
                      style: AppTypography.h2_20SemiBold.copyWith(
                        color: context.colors.titles,
                      ),
                    ),
                    const Gap(10),

                    // Price and Condition Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${product.price} ILS',
                              style: AppTypography.h3_18Medium.copyWith(
                                color: context.colors.mainColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (product.isNegotiable)
                              Text(
                                "Price is negotiable",
                                style: AppTypography.label12Regular.copyWith(
                                  color: context.colors.text.withOpacity(0.6),
                                ),
                              ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: context.colors.mainColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            product.condition.isNotEmpty
                                ? product.condition
                                : "New",
                            style: AppTypography.body14Medium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),

                    // Description
                    Text(
                      "Description",
                      style: AppTypography.h3_18Medium.copyWith(
                        color: context.colors.titles,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      product.description.isNotEmpty
                          ? product.description
                          : "No description provided for this item.",
                      style: AppTypography.body14Regular.copyWith(
                        color: context.colors.text,
                      ),
                    ),
                    const Gap(25),

                    // Key Features
                    _buildExpandableSection("Key features"),
                    const Gap(20),

                    // Seller Info
                    _buildSellerSection(),
                    const Gap(20),

                    // Location
                    _buildLocationSection(),
                    const Gap(20),

                    // More from seller
                    _buildMoreFromSeller(),

                    const Gap(100), // Space for bottom bar
                  ]),
                ),
              ),
            ],
          ),

          // Custom AppBar Overlaid
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircularButton(
                  icon: Icons.arrow_back_ios_new,
                  onTap: () => context.pop(),
                ),
                Row(
                  children: [
                    _buildCircularButton(
                      icon: Icons.share_outlined,
                      onTap: () {},
                    ),
                    const Gap(10),
                    _buildCircularButton(icon: Icons.more_vert, onTap: () {}),
                  ],
                ),
              ],
            ),
          ),

          // Fixed Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(context, product),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, ProductModel product) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      decoration: BoxDecoration(
        color: context.colors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: context.colors.border),
              ),
              child: const Icon(Icons.favorite, color: Colors.red, size: 24),
            ),
            const Gap(15),
            Expanded(
              child: ElevatedButton(
                onPressed:
                    () => context.pushNamed(
                      AppRoutes.chating,
                      extra: {'product': product},
                    ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB), // Premium Blue
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Chat with seller",
                  style: AppTypography.body16Medium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.colors.border.withOpacity(0.5)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.body16Medium.copyWith(
              color: context.colors.titles,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.keyboard_arrow_down, color: context.colors.icons),
        ],
      ),
    );
  }

  Widget _buildSellerSection() {
    return Row(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 10, color: Colors.white),
              ),
            ),
          ],
        ),
        const Gap(15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Eleanor Vance",
                style: AppTypography.body16Medium.copyWith(
                  color: context.colors.titles,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "2 Active listing - 10 Sold listing",
                style: AppTypography.label12Regular.copyWith(
                  color: context.colors.text.withOpacity(0.6),
                ),
              ),
              Text(
                "Last online 1 week ago",
                style: AppTypography.label12Regular.copyWith(
                  color: context.colors.text.withOpacity(0.6),
                ),
              ),
              Text(
                "Avg. response time: within 1 hour",
                style: AppTypography.label12Regular.copyWith(
                  color: context.colors.text.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on, color: context.colors.mainColor, size: 20),
            const Gap(5),
            Text(
              "Gaza, Palestine",
              style: AppTypography.body14Medium.copyWith(
                color: context.colors.titles,
              ),
            ),
          ],
        ),
        const Gap(10),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            'https://media.wired.com/photos/59269770af95806129f50b5e/master/w_2560%2Cc_limit/GoogleMap-600x338.jpg',
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder:
                (_, __, ___) => Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.network(
                    'https://static-maps.yandex.ru/1.x/?lang=en_US&ll=34.45,31.5&z=13&l=map&size=600,300',
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => const Center(
                          child: Icon(
                            Icons.map_outlined,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                  ),
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoreFromSeller() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "More from this seller",
              style: AppTypography.h3_18Medium.copyWith(
                color: context.colors.titles,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text("See All", style: AppTypography.body14Medium),
            ),
          ],
        ),
        const Gap(10),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            separatorBuilder: (_, __) => const Gap(15),
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.colors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          index == 0
                              ? 'https://m.media-amazon.com/images/I/71ZOtNdaZCL._AC_SL1500_.jpg'
                              : 'https://m.media-amazon.com/images/I/61jC+kZcllL._AC_SL1500_.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            index == 0 ? "iPhone 14 Pro Max" : "iPad Pro 11",
                            style: AppTypography.body14Medium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            index == 0 ? "2000 ILS" : "500 ILS",
                            style: AppTypography.body14Medium.copyWith(
                              color: context.colors.mainColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 12,
                                color: context.colors.icons,
                              ),
                              Text(
                                " Gaza",
                                style: AppTypography.label12Regular,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getTimeAgo(DateTime? date) {
    if (date == null) return "2 days ago";
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return "${diff.inDays} days ago";
    if (diff.inHours > 0) return "${diff.inHours} hours ago";
    return "recently";
  }
}
