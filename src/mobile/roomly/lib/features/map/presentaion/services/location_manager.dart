import 'package:geolocator/geolocator.dart';
import 'cubic/search_location_result.dart';
import 'location_service.dart';
import 'secure_storage_service.dart';
import 'geocoding_service.dart';

class LocationManager {
  static final LocationManager _instance = LocationManager._internal();
  factory LocationManager() => _instance;
  LocationManager._internal();

  final LocationService _locationService = LocationService();
  final SecureStorageAddressServices _storageService = SecureStorageAddressServices();
  final GeocodingService _geocodingService = GeocodingService();
  /// الحصول على معلومات مفصلة عن الموقع
  Future<DetailedLocationInfo?> getDetailedLocationInfo(
      double latitude, double longitude) async {
    return await _geocodingService.getDetailedLocationInfo(latitude, longitude);
  }


  Future<UserLocationResult> getInitialUserLocation() async {
    try {

      Position? currentPosition = await _locationService.getCurrentLocation();

      if (currentPosition != null) {
        // تحويل الإحداثيات إلى عنوان
        String? address = await _geocodingService.getAddressFromCoordinates(
          currentPosition.latitude,
          currentPosition.longitude,
        );
        
        // حفظ الموقع الجديد
        await _storageService.saveUserLocation(
          latitude: currentPosition.latitude,
          longitude: currentPosition.longitude,
          address: address,
          locationName: address?.split(',').first,
        );
        
        return UserLocationResult(
          latitude: currentPosition.latitude,
          longitude: currentPosition.longitude,
          address: address,
          locationName: address?.split(',').first ?? 'الموقع الحالي',
          source: LocationSource.gps,
        );
      }

      // المحاولة الثانية: استخدام الموقع المحفوظ
      UserLocationData? savedLocation = await _storageService.getUserLocation();
      if (savedLocation != null) {
        return UserLocationResult(
          latitude: savedLocation.latitude,
          longitude: savedLocation.longitude,
          address: savedLocation.address,
          locationName: savedLocation.locationName ?? 'موقع محفوظ',
          source: LocationSource.storage,
        );
      }

      // المحاولة الثالثة: استخدام العنوان المحفوظ
      String? savedAddress = await _storageService.getUserAddress();
      if (savedAddress != null && savedAddress.isNotEmpty) {
        LocationCoordinates? coordinates = await _geocodingService.getCoordinatesFromAddress(savedAddress);
        
        if (coordinates != null) {
          // حفظ الإحداثيات المحولة
          await _storageService.saveUserLocation(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude,
            address: savedAddress,
            locationName: savedAddress.split(',').first,
          );
          
          return UserLocationResult(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude,
            address: savedAddress,
            locationName: savedAddress.split(',').first,
            source: LocationSource.address,
          );
        }
      }

      // الخيار الأخير: استخدام الموقع الافتراضي (الدقي)
      LocationCoordinates dokkiCoordinates = await _geocodingService.getDokkiCoordinates();
      
      // حفظ الموقع الافتراضي
      await _storageService.saveUserLocation(
        latitude: dokkiCoordinates.latitude,
        longitude: dokkiCoordinates.longitude,
        address: 'الدقي، الجيزة، مصر',
        locationName: 'الدقي',
      );
      
      return UserLocationResult(
        latitude: dokkiCoordinates.latitude,
        longitude: dokkiCoordinates.longitude,
        address: 'الدقي، الجيزة، مصر',
        locationName: 'الدقي',
        source: LocationSource.defaultLocation,
      );
      
    } catch (e) {
      print('خطأ في الحصول على الموقع الأولي: $e');
      
      // في حالة الخطأ، إرجاع الموقع الافتراضي
      return UserLocationResult(
        latitude: 30.0384,
        longitude: 31.2108,
        address: 'الدقي، الجيزة، مصر',
        locationName: 'الدقي',
        source: LocationSource.defaultLocation,
      );
    }
  }

  /// تحديث موقع المستخدم وحفظه
  Future<bool> updateUserLocation({
    required double latitude,
    required double longitude,
    String? address,
    String? locationName,
  }) async {
    try {
      // إذا لم يتم توفير العنوان، احصل عليه من الإحداثيات
      if (address == null) {
        address = await _geocodingService.getAddressFromCoordinates(latitude, longitude);
      }
      
      // إذا لم يتم توفير اسم الموقع، استخدم أول جزء من العنوان
      if (locationName == null && address != null) {
        locationName = address.split(',').first.trim();
      }
      
      // حفظ الموقع الجديد
      await _storageService.saveUserLocation(
        latitude: latitude,
        longitude: longitude,
        address: address,
        locationName: locationName,
      );
      
      return true;
    } catch (e) {
      print('خطأ في تحديث موقع المستخدم: $e');
      return false;
    }
  }

  /// البحث عن المواقع
  Future<List<SearchLocationResult>> searchLocations(String query) async {
    return await _geocodingService.searchLocations(query);
  }

  /// الحصول على الموقع المحفوظ
  Future<UserLocationData?> getSavedLocation() async {
    return await _storageService.getUserLocation();
  }
  Future<Map<String, dynamic>?> getSavedLocationFromSearch() async {
    return await _storageService.getSavedAddressForSearch();
  }

  /// مسح الموقع المحفوظ
  Future<void> clearSavedLocation() async {
    await _storageService.clearUserLocation();
  }

  /// التحقق من حالة أذونات الموقع
  Future<LocationPermissionStatus> getLocationPermissionStatus() async {
    return await _locationService.getLocationPermissionStatus();
  }

  /// طلب أذونات الموقع
  Future<bool> requestLocationPermission() async {
    return await _locationService.requestLocationPermission();
  }

  /// فتح إعدادات الموقع
  Future<void> openLocationSettings() async {
    await _locationService.openLocationSettings();
  }

  /// الحصول على الموقع الحالي مباشرة
  Future<Position?> getCurrentLocation() async {
    return await _locationService.getCurrentLocation();
  }

  /// حساب المسافة بين نقطتين
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return _locationService.calculateDistance(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}

/// فئة لتمثيل نتيجة الحصول على موقع المستخدم
class UserLocationResult {
  final double latitude;
  final double longitude;
  final String? address;
  final String locationName;
  final LocationSource source;

  UserLocationResult({
    required this.latitude,
    required this.longitude,
    this.address,
    required this.locationName,
    required this.source,
  });

  @override
  String toString() {
    return 'UserLocationResult(lat: $latitude, lng: $longitude, name: $locationName, source: $source)';
  }
}

/// مصادر الموقع
enum LocationSource {
  gps,           // من GPS الحالي
  storage,       // من التخزين المحفوظ
  address,       // من العنوان المحفوظ
  defaultLocation, // الموقع الافتراضي
}

