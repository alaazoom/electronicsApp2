// import 'package:flutter/material.dart';
// import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
// import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';
// import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';
// import 'package:second_hand_electronics_marketplace/core/widgets/category_item.dart';

// /// Data model for a category item
// class CategoryData {
//   final String title;
//   final IconData iconData;

//   const CategoryData({required this.title, required this.iconData});
// }

// /// Header widget for the categories section
// /// Displays "Categories" title and "See All" action button
// class CategoriesHeader extends StatelessWidget {
//   const CategoriesHeader({
//     super.key,
//     this.onSeeAllTap,
//     this.title = 'Categories',
//     this.seeAllText = 'See All',
//   });

//   /// Callback when "See All" is tapped
//   final VoidCallback? onSeeAllTap;

//   /// The header title (default: "Categories")
//   final String title;

//   /// The action button text (default: "See All")
//   final String seeAllText;

//   @override
//   Widget build(BuildContext context) {
//     final colors = context.colors;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Title
//           // CSS: Poppins, 18px, Medium (500), Color #212121
//           Text(
//             title,
//             style: AppTypography.h3_18Medium.copyWith(
//               color: colors.titles, // #212121 in light theme
//             ),
//           ),

//           // "See All" link
//           // Figma: Reg-14, color: hint
//           if (onSeeAllTap != null)
//             GestureDetector(
//               onTap: onSeeAllTap,
//               behavior: HitTestBehavior.opaque,
//               child: Text(
//                 seeAllText,
//                 style: AppTypography.body14Regular.copyWith(color: colors.hint),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// /// The main categories section widget that combines the header
// /// with a horizontal scrolling list of category items.
// class CategoriesSection extends StatelessWidget {
//   const CategoriesSection({
//     super.key,
//     this.categories,
//     this.onSeeAllTap,
//     this.onCategoryTap,
//     this.headerPadding = const EdgeInsets.symmetric(horizontal: 0),
//     this.listPadding = const EdgeInsets.symmetric(
//       horizontal: AppSizes.paddingL,
//     ),
//     this.itemSpacing = AppSizes.paddingS, // 12px per Figma
//     this.headerToListSpacing = AppSizes.paddingS, // 12px per Figma
//     this.listHeight = 100.0,
//   });

//   /// List of categories to display. If null, default electronics categories are used.
//   final List<CategoryData>? categories;

//   /// Callback when "See All" is tapped
//   final VoidCallback? onSeeAllTap;

//   /// Callback when a category is tapped, receives the category title
//   final void Function(String categoryTitle)? onCategoryTap;

//   /// Padding around the header
//   final EdgeInsets headerPadding;

//   /// Padding for the horizontal list
//   final EdgeInsets listPadding;

//   /// Spacing between category items
//   final double itemSpacing;

//   /// Spacing between header and list
//   final double headerToListSpacing;

//   /// Height of the list container
//   final double listHeight;

//   /// Default electronics categories for the app
//   static const List<CategoryData> defaultCategories = [
//     CategoryData(title: 'Phones', iconData: Icons.phone_android),
//     CategoryData(title: 'Tablets', iconData: Icons.tablet_android),
//     CategoryData(title: 'Laptops', iconData: Icons.laptop),
//     CategoryData(title: 'PC Parts', iconData: Icons.memory),
//     CategoryData(title: 'Gaming', iconData: Icons.sports_esports),
//     CategoryData(title: 'Audio', iconData: Icons.headphones),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final effectiveCategories = categories ?? defaultCategories;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // 1. Header
//         Padding(
//           padding: headerPadding,
//           child: CategoriesHeader(onSeeAllTap: onSeeAllTap),
//         ),

//         SizedBox(height: headerToListSpacing),

//         // 2. Horizontal List
//         SizedBox(
//           height:
//               listHeight, // Sufficient height for Circle(56) + Gap(12) + Text(~18)
//           child: ListView.separated(
//             padding: listPadding,
//             scrollDirection: Axis.horizontal,
//             itemCount: effectiveCategories.length,
//             separatorBuilder: (context, index) => SizedBox(width: itemSpacing),
//             itemBuilder: (context, index) {
//               final category = effectiveCategories[index];
//               return CategoryItem(
//                 title: category.title,
//                 iconData: category.iconData,
//                 onTap:
//                     onCategoryTap != null
//                         ? () => onCategoryTap!(category.title)
//                         : null,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
