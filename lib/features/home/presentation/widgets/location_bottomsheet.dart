import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import 'package:second_hand_electronics_marketplace/features/location/data/models/city_model.dart';
import 'package:second_hand_electronics_marketplace/features/location/data/models/country_model.dart';
// تأكدي من مسار المودلز
import 'package:second_hand_electronics_marketplace/core/constants/cache_keys.dart';
import 'package:second_hand_electronics_marketplace/core/helpers/cache_helper.dart';
import 'package:second_hand_electronics_marketplace/features/location/presentation/cubits/location_cubit.dart';
import 'package:second_hand_electronics_marketplace/features/location/presentation/cubits/location_states.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LocationPermissionSheet extends StatelessWidget {
  // ✅ 1. ضفنا هدول عشان نستقبل المدينة من الشاشة السابقة
  final CountryModel selectedCountry;
  final CityModel selectedCity;

  const LocationPermissionSheet({
    super.key,
    required this.selectedCountry,
    required this.selectedCity,
  });

  @override
  Widget build(BuildContext context) {
    final locationCubit = context.read<LocationCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(AppAssets.locationFilledIcon),
          const SizedBox(height: AppSizes.paddingL),
          Text(
            'Set your exact location to find nearby products',
            textAlign: TextAlign.center,
            style: AppTypography.h3_18Medium.copyWith(
              color: context.colors.text,
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),

          // 📍 زر الخريطة
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.pushNamed(
                  AppRoutes.location,
                  extra: {
                    'initialLat': selectedCity.latitude,
                    'initialLng': selectedCity.longitude,
                    'fallbackCountry': selectedCountry.nameEn, // English
                    'fallbackCity': selectedCity.nameEn, // English
                  },
                );
              },
              child: const Text('Pick a place'),
            ),
          ),

          const SizedBox(height: AppSizes.paddingM),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () async {
                EasyLoading.show();

                await locationCubit.getCurrentLocation();

                if (context.mounted) {
                  EasyLoading.dismiss(); // إغلاق اللودينج

                  await CacheHelper.saveData(
                    key: CacheKeys.isFirstTime,
                    value: false,
                  );

                  // إذا نجح الـ GPS
                  if (locationCubit.state is LocationLoaded) {
                    context.goNamed(AppRoutes.mainLayout);
                  } else {
                    await locationCubit.setLocationDirectly(
                      lat: selectedCity.latitude,
                      lng: selectedCity.longitude,
                      country: selectedCountry.nameEn, // English
                      city: selectedCity.nameEn, // English
                    );
                    context.goNamed(AppRoutes.mainLayout);
                  }
                }
              },
              child: const Text('Setup GPS'),
            ),
          ),

          TextButton(
            onPressed: () async {
              EasyLoading.show();

              await locationCubit.setLocationDirectly(
                lat: selectedCity.latitude,
                lng: selectedCity.longitude,
                country: selectedCountry.nameEn, // English
                city: selectedCity.nameEn, // English
              );

              if (context.mounted) {
                EasyLoading.dismiss();
                await CacheHelper.saveData(
                  key: CacheKeys.isFirstTime,
                  value: false,
                );
                context.goNamed(AppRoutes.mainLayout);
              }
            },
            child: const Text('Skip'),
          ),
        ],
      ),
    );
  }
}
