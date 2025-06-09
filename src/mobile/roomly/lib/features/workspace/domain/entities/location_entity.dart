import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final String id;
  final double? longitude;
  final double? latitude;
  final String? city;
  final String? town;
  final String? country;

  const LocationEntity({
    required this.id,
    this.longitude,
    this.latitude,
    this.city,
    this.town,
    this.country,
  });

  @override
  List<Object?> get props => [
        id,
        longitude,
        latitude,
        city,
        town,
        country,
      ];
}


