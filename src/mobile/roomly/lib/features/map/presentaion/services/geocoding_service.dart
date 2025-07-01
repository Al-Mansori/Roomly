import 'package:geocoding/geocoding.dart';

import 'cubic/search_location_result.dart';

class GeocodingService {
  static final GeocodingService _instance = GeocodingService._internal();
  factory GeocodingService() => _instance;
  static late String street;
  GeocodingService._internal();

  Future<LocationCoordinates?> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      
      if (locations.isNotEmpty) {
        Location location = locations.first;
        return LocationCoordinates(
          latitude: location.latitude,
          longitude: location.longitude,
        );
      }
      return null;
    } catch (e) {
      print('error converting address to coordinates: $e');
      return null;
    }
  }

  Future<String?> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;

        List<String> addressParts = [];


        if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
          addressParts.add(placemark.subLocality!);
        }

        if (placemark.locality != null && placemark.locality!.isNotEmpty) {
          addressParts.add(placemark.locality!);
        }

        if (placemark.administrativeArea != null && placemark.administrativeArea!.isNotEmpty) {
          addressParts.add(placemark.administrativeArea!);
        }

        if (placemark.country != null && placemark.country!.isNotEmpty) {
          addressParts.add(placemark.country!);
        }
        return addressParts.join(', ');
      }
      return null;
    } catch (e) {
      print('error converting from coordinates to address: $e');
      return null;
    }
  }

  Future<DetailedLocationInfo?> getDetailedLocationInfo(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;

        // Build readable address manually
        String formattedAddress = [
          placemark.subLocality,
          placemark.locality,
          placemark.administrativeArea,
          placemark.country
        ].where((e) => e != null && e.isNotEmpty).join(', ');


        return DetailedLocationInfo(
          subLocality: placemark.subLocality,
          locality: placemark.locality,
          subAdministrativeArea: placemark.subAdministrativeArea,
          administrativeArea: placemark.administrativeArea,
          postalCode: placemark.postalCode,
          country: placemark.country,
          isoCountryCode: placemark.isoCountryCode,
          formattedAddress: formattedAddress,
        );
      }
      return null;
    } catch (e) {
      print('error getting detailed location: $e');
      return null;
    }
  }
  Future<String?> getStreetOnlyFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final street = placemarks.first.street;
        return (street != null && street.isNotEmpty) ? street : 'location in map';
      }

      return 'location in map';
    } catch (e) {
      print('Error getting street from coordinates: $e');
      return 'location on map';
    }
  }

  Future<List<SearchLocationResult>> searchLocations(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      List<SearchLocationResult> results = [];
      
      for (Location location in locations) {
        String? address = await getAddressFromCoordinates(
          location.latitude, 
          location.longitude
        );
        
        results.add(SearchLocationResult(
          latitude: location.latitude,
          longitude: location.longitude,
          address: address ?? query,
          displayName: address ?? query,
        ));
      }

      return results;
    } catch (e) {
      print('خطأ في البحث عن المواقع: $e');
      return [];
    }
  }

  Future<LocationCoordinates> getDokkiCoordinates() async {
    try {
      LocationCoordinates? coordinates = await getCoordinatesFromAddress('Dokki, Giza, Egypt');
      
      return coordinates ?? const LocationCoordinates(
        latitude: 30.0384, 
        longitude: 31.2108
      );
    } catch (e) {
      print('خطأ في الحصول على إحداثيات الدقي: $e');
      // إرجاع الإحداثيات المعروفة للدقي كقيمة افتراضية
      return const LocationCoordinates(
        latitude: 30.0384, 
        longitude: 31.2108
      );
    }
  }
}

/// فئة لتمثيل الإحداثيات
class LocationCoordinates {
  final double latitude;
  final double longitude;

  const LocationCoordinates({
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() {
    return 'LocationCoordinates(lat: $latitude, lng: $longitude)';
  }
}

/// فئة لتمثيل معلومات الموقع المفصلة
class DetailedLocationInfo {
  final String? street;
  final String? subLocality;
  final String? locality;
  final String? subAdministrativeArea;
  final String? administrativeArea;
  final String? postalCode;
  final String? country;
  final String? isoCountryCode;

  DetailedLocationInfo({
    this.street,
    this.subLocality,
    this.locality,
    this.subAdministrativeArea,
    this.administrativeArea,
    this.postalCode,
    this.country,
    this.isoCountryCode, required String formattedAddress,
  });

  String get formattedAddress {
    List<String> parts = [];
    if (street != null) parts.add(street!);
    if (subLocality != null) parts.add(subLocality!);
    if (locality != null) parts.add(locality!);
    if (administrativeArea != null) parts.add(administrativeArea!);
    if (country != null) parts.add(country!);
    return parts.join(', ');
  }

  @override
  String toString() {
    return 'DetailedLocationInfo(${formattedAddress})';
  }
}

