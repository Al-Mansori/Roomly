import 'package:flutter/foundation.dart';

import '../cubic/search_location_result.dart';

class LocationState {
  const LocationState();
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationLoaded extends LocationState {
  final double latitude;
  final double longitude;
  final String locationName;
  final String? address;
  final String? street; // 👈 تمت إضافة خاصية الشارع

  const LocationLoaded({
    required this.latitude,
    required this.longitude,
    required this.locationName,
    this.address,
    this.street,
  });
}

class LocationSelected extends LocationState {
  final double latitude;
  final double longitude;
  final String locationName;
  final String? address;
  final String? street; // 👈 تمت إضافة خاصية الشارع

  const LocationSelected({
    required this.latitude,
    required this.longitude,
    required this.locationName,
    this.address,
    this.street,
  });
}

class LocationSaving extends LocationState {
  final double latitude;
  final double longitude;
  final String locationName;

  const LocationSaving({
    required this.latitude,
    required this.longitude,
    required this.locationName,
  });
}

class LocationSaved extends LocationState {
  final double latitude;
  final double longitude;
  final String locationName;
  final String? street;

  const LocationSaved({
    required this.latitude,
    required this.longitude,
    required this.locationName,
    this.street,
  });

  @override
  List<Object?> get props => [latitude, longitude, locationName, street];
}


class LocationSearching extends LocationState {
  const LocationSearching();
}

class LocationSearchResults extends LocationState {
  final List<SearchLocationResult> results;

  const LocationSearchResults(this.results);
}

class LocationError extends LocationState {
  final String message;

  const LocationError(this.message);
}
