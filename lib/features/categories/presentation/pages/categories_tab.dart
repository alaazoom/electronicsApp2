import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_assets.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_routes.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_strings.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/category_item.dart';
import 'package:second_hand_electronics_marketplace/features/categories/presentation/cubits/category_cubit.dart';
import 'package:second_hand_electronics_marketplace/features/categories/presentation/cubits/category_states.dart';
import 'package:second_hand_electronics_marketplace/features/products/data/models/product_model.dart';
import 'package:second_hand_electronics_marketplace/features/products/presentation/cubit/products_cubit.dart';

class CategoriesTab extends StatelessWidget {
  const CategoriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'name': 'Smartphones', 'icon': AppAssets.smartPhoneCatIcon},
      {'name': 'Tablets', 'icon': AppAssets.tabletCatIcon},
      {'name': 'Laptops', 'icon': AppAssets.laptopCatIcon},
      {'name': 'AI Chips', 'icon': AppAssets.aiChipCatIcon},
      {'name': 'Gaming Consoles', 'icon': AppAssets.gameCatIcon},
      {'name': 'Audio Devices', 'icon': AppAssets.headphoneCatIcon},
      {'name': 'Watches', 'icon': AppAssets.smartWatchCatIcon},
      {'name': 'Cameras', 'icon': AppAssets.cameraCatIcon},
      {'name': 'Routers', 'icon': AppAssets.routerCatIcon},
      {'name': 'TVs', 'icon': AppAssets.tvCatIcon},
      {'name': 'Plugs', 'icon': AppAssets.plugCatIcon},
      {'name': 'Wifi', 'icon': AppAssets.wifiCatIcon},
    ];

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.categories,
          style: AppTypography.h2_20SemiBold.copyWith(
            color: context.colors.titles,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: AppSizes.paddingS,
          mainAxisSpacing: AppSizes.paddingS,
          childAspectRatio: 1.0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryItem(
            title: category['name'],
            iconPath: category['icon'],
            isSelected: false,
            onTap: () {
              // البحث عن الـ ID الحقيقي من السيرفر بناءً على الاسم
              final categoryState = context.read<CategoryCubit>().state;
              String? realId;

              if (categoryState is CategorySuccess) {
                try {
                  final searchName = category['name'].toString().toLowerCase();
                  realId =
                      categoryState.response.data.firstWhere((c) {
                        final serverName = c.name.toLowerCase();
                        return serverName == searchName ||
                            serverName.contains(searchName) ||
                            searchName.contains(serverName);
                      }).id;
                } catch (_) {}
              }

              // جلب المنتجات المفلترة
              context.read<ProductsCubit>().fetchProducts(categoryId: realId);

              context.pushNamed(
                AppRoutes.listings,
                extra: {
                  'title': category['name'],
                  'listings':
                      <ProductModel>[], // سنعتمد على الـ BlocBuilder في الصفحة
                },
              );
            },
          );
        },
      ),
    );
  }
}
