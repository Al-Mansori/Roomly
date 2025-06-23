// import 'package:roomly/features/workspace/domain/entities/location_entity.dart';

// class LocationModel extends LocationEntity {
//   const LocationModel({
//     required String id,
//     double? longitude,
//     double? latitude,
//     String? city,
//     String? town,
//     String? country,
//   }) : super(
//           id: id,
//           longitude: longitude,
//           latitude: latitude,
//           city: city,
//           town: town,
//           country: country,
//         );

//   factory LocationModel.fromJson(Map<String, dynamic> json) {
//     return LocationModel(
//       id: json["Id"],
//       longitude: json["Longitude"]?.toDouble(),
//       latitude: json["Latitude"]?.toDouble(),
//       city: json["City"],
//       town: json["Town"],
//       country: json["Country"],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "Id": id,
//       "Longitude": longitude,
//       "Latitude": latitude,
//       "City": city,
//       "Town": town,
//       "Country": country,
//     };
//   }
// }



// v2 --------------------------------------------------------------


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


