import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/search_widget.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/custom_radio_button_item.dart';
import 'package:second_hand_electronics_marketplace/features/home/presentation/widgets/location_bottomsheet.dart';
import 'package:second_hand_electronics_marketplace/features/location/data/models/city_model.dart';
import 'package:second_hand_electronics_marketplace/features/location/data/models/country_model.dart';

class CitySelectionScreen extends StatefulWidget {
  final CountryModel selectedCountry;

  const CitySelectionScreen({super.key, required this.selectedCountry});

  @override
  State<CitySelectionScreen> createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CityModel> _filteredCities = [];
  CityModel? _selectedCity; // ✅ ضفنا متغير لحفظ المدينة المختارة

  @override
  void initState() {
    super.initState();
    _filteredCities = widget.selectedCountry.cities;
    _searchController.addListener(_filterCities);
  }

  void _filterCities() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredCities = widget.selectedCountry.cities;
      } else {
        _filteredCities =
            widget.selectedCountry.cities.where((city) {
              return city.nameAr.contains(query) ||
                  city.nameEn.toLowerCase().contains(query);
            }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // دالة إظهار الشيت
  void _showLocationSheet() {
    if (_selectedCity == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => LocationPermissionSheet(
            selectedCountry: widget.selectedCountry,
            selectedCity: _selectedCity!,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('City'), leading: const BackButton()),
        body: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose your city in ${widget.selectedCountry.nameEn}',
                style: AppTypography.h3_18Medium.copyWith(
                  color: context.colors.titles,
                ),
              ),
              const SizedBox(height: AppSizes.paddingM),

              SearchWidget(controller: _searchController, onChanged: (val) {}),
              const SizedBox(height: AppSizes.paddingL),

              Expanded(
                child:
                    _filteredCities.isEmpty
                        ? Center(
                          child: Text(
                            'لا توجد مدن مطابقة لبحثك',
                            style: AppTypography.body16Regular.copyWith(
                              color: context.colors.text,
                            ),
                          ),
                        )
                        : ListView.separated(
                          itemCount: _filteredCities.length,
                          separatorBuilder:
                              (context, index) =>
                                  const SizedBox(height: AppSizes.paddingM),
                          itemBuilder: (context, index) {
                            final city = _filteredCities[index];

                            final isSelected = _selectedCity?.id == city.id;

                            return CustomRadioButtonItem(
                              label: city.nameEn,
                              isSelected: isSelected,
                              onTap: () {
                                setState(() {
                                  _selectedCity = city;
                                });
                              },
                            );
                          },
                        ),
              ),

              if (_selectedCity != null) ...[
                const SizedBox(height: AppSizes.paddingM),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _showLocationSheet,
                    child: Text(AppStrings.confirm),
                  ),
                ),
                const SizedBox(height: AppSizes.paddingM),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
