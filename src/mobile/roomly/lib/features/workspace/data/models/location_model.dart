import 'package:roomly/features/workspace/domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({
    required String id,
    double? longitude,
    double? latitude,
    String? city,
    String? town,
    String? country,
  }) : super(
          id: id,
          longitude: longitude,
          latitude: latitude,
          city: city,
          town: town,
          country: country,
        );

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json["id"],
      longitude: json["longitude"]?.toDouble(),
      latitude: json["latitude"]?.toDouble(),
      city: json["city"],
      town: json["town"],
      country: json["country"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "longitude": longitude,
      "latitude": latitude,
      "city": city,
      "town": town,
      "country": country,
    };
  }
}


