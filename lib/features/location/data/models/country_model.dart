import 'package:second_hand_electronics_marketplace/features/location/data/models/city_model.dart';

class CountryModel {
  final String id;
  final String nameEn;
  final String nameAr;
  final String isoCode;
  final bool isActive;
  final List<CityModel> cities;

  CountryModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.isoCode,
    required this.isActive,
    required this.cities,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id']?.toString() ?? '',
      nameEn: json['nameEn'] ?? '',
      nameAr: json['nameAr'] ?? '',
      isoCode: json['isoCode'] ?? '',
      isActive: json['isActive'] ?? false,
      cities:
          json['cities'] != null
              ? (json['cities'] as List)
                  .map((c) => CityModel.fromJson(c))
                  .toList()
              : [],
    );
  }
}
