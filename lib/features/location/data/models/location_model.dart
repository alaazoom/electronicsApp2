import 'package:equatable/equatable.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_keys.dart';

class LocationModel extends Equatable {
  const LocationModel(
    this.lat,
    this.lng,
    this.address,
    this.country,
    this.city,
  );
  final double lat;
  final double lng;
  final String address;
  final String country;
  final String city;

  Map<String, dynamic> toMap() {
    return {
      AppKeys.latitude: lat,
      AppKeys.longitude: lng,
      AppKeys.address: address,
      AppKeys.country: country,
      AppKeys.city: city,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      map[AppKeys.latitude]?.toDouble() ?? 0.0,
      map[AppKeys.longitude]?.toDouble() ?? 0.0,
      map[AppKeys.address] ?? '',
      map[AppKeys.country] ?? '',
      map[AppKeys.city] ?? '',
    );
  }
  @override
  List<Object?> get props => [lat, lng, address, country, city];
}
