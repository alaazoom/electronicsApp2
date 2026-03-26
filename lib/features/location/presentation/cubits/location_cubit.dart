import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:second_hand_electronics_marketplace/core/constants/cache_keys.dart';
import 'package:second_hand_electronics_marketplace/core/helpers/cache_helper.dart';
import 'package:second_hand_electronics_marketplace/features/location/data/models/location_model.dart';
import 'package:second_hand_electronics_marketplace/features/location/presentation/cubits/location_states.dart';

class LocationCubit extends Cubit<LocationStates> {
  LocationCubit() : super(LocationInitial()) {
    _loadSavedLocation();
  }

  void _loadSavedLocation() {
    try {
      String? locationData = CacheHelper.getData(key: CacheKeys.location);
      if (locationData != null) {
        final map = jsonDecode(locationData);
        emit(LocationLoaded(LocationModel.fromMap(map)));
      }
    } catch (e) {
      // Handle or ignore parsing error
    }
  }

  Position? currentPosition;
  double? celsius;
  String formatedCelsius = '';

  // Get GPS location
  Future<void> getCurrentLocation() async {
    emit(LocationLoading());
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        emit(
          LocationError(
            'Location service is disabled. Go to settings to enable it.',
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(
            LocationError(
              'Location permission denied. Go to settings to enable it.',
            ),
          );
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        emit(
          LocationError(
            'Location permission permanently denied. Go to settings to enable it.',
          ),
        );
        return;
      }

      currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Location fetch timed out'),
      );

      await _updateLocationModel(
        currentPosition!.latitude,
        currentPosition!.longitude,
      );
    } catch (e) {
      emit(LocationError('Error getting location: $e'));
    }
  }

  // Set manually selected location (from Map)
  Future<void> setSelectedLocation(double lat, double lng) async {
    await _updateLocationModel(lat, lng);
  }

  Future<void> _updateLocationModel(double lat, double lng) async {
    try {
      var address = await _getAddressFromCoordinates(lat, lng);
      LocationModel selectedLocation = LocationModel(
        lat,
        lng,
        address.address,
        address.country,
        address.city,
      );
      await CacheHelper.saveData(
        key: CacheKeys.location,
        value: jsonEncode(selectedLocation.toMap()),
      );
      emit(LocationLoaded(selectedLocation));
    } catch (e) {
      emit(LocationError('Error updating location: $e'));
    }
  }

  Future<({String address, String country, String city})>
  _getAddressFromCoordinates(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty)
        return (address: 'Address not found', country: '', city: '');
      final p = placemarks.first;
      return formattedAdderss(p);
    } catch (e) {
      return (address: 'error getting address', country: '', city: '');
    }
  }

  setLocation(LocationModel? location) {
    if (location != null) {
      if (location.address.isNotEmpty) {
        emit(LocationLoaded(location));
      }
    } else {
      emit(LocationInitial());
    }
  }

  void clearLocation() {
    emit(LocationInitial());
  }

  ({String address, String country, String city}) formattedAdderss(
    Placemark p,
  ) {
    return (
      address:
          [
            if (p.subLocality?.isNotEmpty ?? false) p.subLocality,
            if (p.thoroughfare?.isNotEmpty ?? false) p.thoroughfare,
            if (p.subThoroughfare?.isNotEmpty ?? false) p.subThoroughfare,
            if (p.postalCode?.isNotEmpty ?? false) p.postalCode,
            if (p.subAdministrativeArea?.isNotEmpty ?? false)
              p.subAdministrativeArea,
            if (p.administrativeArea?.isNotEmpty ?? false) p.administrativeArea,
            if (p.country?.isNotEmpty ?? false) p.country,
          ].join(', ').trim(),
      country: p.country ?? '',
      city: p.administrativeArea ?? '',
    );
  }

  // دالة الحفظ المباشر (الشبكة الآمنة)
  Future<void> setLocationDirectly({
    required double lat,
    required double lng,
    required String country,
    required String city,
    String? address, // اختياري
  }) async {
    try {
      LocationModel selectedLocation = LocationModel(
        lat,
        lng,
        address ?? '$city, $country', // لو ما في عنوان، بنحط المدينة والدولة
        country,
        city,
      );
      await CacheHelper.saveData(
        key: CacheKeys.location,
        value: jsonEncode(selectedLocation.toMap()),
      );
      emit(LocationLoaded(selectedLocation));
    } catch (e) {
      emit(LocationError('Error setting location directly: $e'));
    }
  }
}
