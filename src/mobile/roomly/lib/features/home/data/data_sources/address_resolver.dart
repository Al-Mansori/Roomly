import 'package:roomly/features/map/presentaion/services/geocoding_service.dart';

import '../../../map/presentaion/services/secure_storage_service.dart';

class AddressResolver {
  final SecureStorageAddressServices _storage = SecureStorageAddressServices();
  final GeocodingService _geocoding = GeocodingService();

  Future<LocationCoordinates?> resolveAddressToCoordinates() async {
    final searchData = await _storage.getSavedAddressForSearch();
    if (searchData != null) {
      final lat = searchData['latitude'];
      final lng = searchData['longitude'];
      if (lat != null && lng != null) {
        return LocationCoordinates(latitude: lat, longitude: lng);
      }
    }
    final position = await _storage.getUserPosition();
    if (position != null) {
      return LocationCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    }
    final storedAddress = await _storage.getUserAddress();
    if (storedAddress != null && storedAddress.isNotEmpty) {
      final coords = await _geocoding.getCoordinatesFromAddress(storedAddress);
      if (coords != null) return coords;
    }

    print('cant find coordinates');
    return null;
  }
}
