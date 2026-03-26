import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/categories_chip.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/my_listings_widgets/slider_view.dart';

class FilterModel extends StatefulWidget {
  FilterModel({super.key});

  List<String> categories = [
    'All',
    'Phones',
    'Smartwatches',
    'PC Parts',
    'Networking',
    'Accessories',
    'Tablets',
    'Audio',
    'Cameras',
    'Smart Home',
    'Laptops',
    'Gaming',
    'TV & Monitors',
  ];
  List<String> conditions = [
    'All',
    'Brand New',
    'Like New',
    'Excellent',
    'Good',
    'Fair',
  ];

  @override
  State<FilterModel> createState() => _FilterModelState();
}

class _FilterModelState extends State<FilterModel> {
  RangeValues priceRange = const RangeValues(0, 500);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text(
              //   'Filter',
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Filter',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: SvgPicture.asset('assets/svgs/Close_Square.svg'),
                ),
              ),
            ],
          ),
          Gap(20),
          Text('Categories'),
          Gap(10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var category in widget.categories)
                CategoriesChip(label: category, onSelected: (isSelected) {}),
            ],
          ),
          Gap(20),
          Text('Price'),
          Gap(10),
          SliderView(min: 1, max: 1000),

          Gap(20),
          Text('Condition'),
          Gap(10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var condition in widget.conditions)
                CategoriesChip(label: condition, onSelected: (isSelected) {}),
            ],
          ),
          Gap(40),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Reset filters
                  },
                  child: Text('Reset', style: TextStyle(color: Colors.black54)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
              ),
              Gap(10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
