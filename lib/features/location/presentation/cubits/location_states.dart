import 'package:second_hand_electronics_marketplace/features/location/data/models/location_model.dart';

abstract class LocationStates {}

class LocationInitial extends LocationStates {}

class LocationLoading extends LocationStates {}

class LocationLoaded extends LocationStates {
  final LocationModel location;
  LocationLoaded(this.location);
}

class LocationError extends LocationStates {
  final String message;
  LocationError(this.message);
}
