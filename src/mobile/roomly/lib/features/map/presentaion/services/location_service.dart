import 'package:geolocator/geolocator.dart';
import 'package:roomly/features/map/presentaion/services/secure_storage_service.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();
  final SecureStorageAddressServices _storageService = SecureStorageAddressServices();

  Future<bool> requestLocationPermission() async {
    try {
      // التحقق من حالة الأذونات الحالية
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        // طلب الأذونات إذا لم تكن ممنوحة
        permission = await Geolocator.requestPermission();
        
        if (permission == LocationPermission.denied) {
          // الأذونات مرفوضة
          return false;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        // الأذونات مرفوضة نهائياً - يجب على المستخدم تفعيلها من الإعدادات
        await openAppSettings();
        return false;
      }
      
      // التحقق من تفعيل خدمات الموقع
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // خدمات الموقع غير مفعلة
        return false;
      }
      
      return true;
    } catch (e) {
      print('خطأ في طلب أذونات الموقع: $e');
      return false;
    }
  }

   LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );


  Future<Position?> getCurrentLocation() async {
    try {
      bool hasPermission = await requestLocationPermission();
      if (!hasPermission) return null;

      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);

      await SecureStorageAddressServices().saveUserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      return position;
    } catch (e) {
      print('error getting current location: $e');
      return null;
    }
  }

  /// الحصول على آخر موقع معروف
  Future<Position?> getLastKnownLocation() async {
    try {
      Position? position = await Geolocator.getLastKnownPosition();
      return position;
    } catch (e) {
      print('خطأ في الحصول على آخر موقع معروف: $e');
      return null;
    }
  }

  /// حساب المسافة بين نقطتين (بالمتر)
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// التحقق من حالة أذونات الموقع
  Future<LocationPermissionStatus> getLocationPermissionStatus() async {
    LocationPermission permission = await Geolocator.checkPermission();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    
    if (!serviceEnabled) {
      return LocationPermissionStatus.serviceDisabled;
    }
    
    switch (permission) {
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.deniedForever;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return LocationPermissionStatus.granted;
      default:
        return LocationPermissionStatus.denied;
    }
  }

  /// فتح إعدادات التطبيق
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// فتح إعدادات التطبيق
  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}

/// حالات أذونات الموقع
enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

