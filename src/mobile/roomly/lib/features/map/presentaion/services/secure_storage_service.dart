import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageAddressServices {
  static final SecureStorageAddressServices _instance = SecureStorageAddressServices._internal();
  factory SecureStorageAddressServices() => _instance;
  SecureStorageAddressServices._internal();

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),

  );

  // مفاتيح التخزين
  static const String _userAddressKey = 'user_address';
  static const String _userLatitudeKey = 'user_latitude';
  static const String _userLongitudeKey = 'user_longitude';
  static const String _userLocationNameKey = 'user_location_name';

  Future<void> saveUserAddressForSearch({
    required double latitude,
    required double longitude,
    required String locationName,
    String? address,
  }) async {
    await _storage.write(key: 'latitude', value: latitude.toString());
    await _storage.write(key: 'longitude', value: longitude.toString());
    await _storage.write(key: 'locationName', value: locationName);
    if (address != null) {
      await _storage.write(key: 'address', value: address);
    }
  }

  Future<Map<String, dynamic>?> getSavedAddressForSearch() async {
    final lat = await _storage.read(key: 'latitude');
    final lng = await _storage.read(key: 'longitude');
    final name = await _storage.read(key: 'locationName');
    final address = await _storage.read(key: 'address');

    if (lat != null && lng != null && name != null) {
      return {
        'latitude': double.parse(lat),
        'longitude': double.parse(lng),
        'locationName': name,
        'address': address,
      };
    }
    return null;
  }

  Future<void> clearSavedAddressForSearch() async {
    await _storage.deleteAll();
  }

  /// حفظ عنوان المستخدم
  Future<void> saveUserAddress(String address) async {
    try {
      await _storage.write(key: _userAddressKey, value: address);
    } catch (e) {
      print('خطأ في حفظ العنوان: $e');
    }
  }

  Future<String?> getUserAddress() async {
    try {
      return await _storage.read(key: _userAddressKey);
    } catch (e) {
      print('خطأ في استرجاع العنوان: $e');
      return null;
    }
  }

  /// حفظ خط العرض للمستخدم
  Future<void> saveUserLatitude(double latitude) async {
    try {
      await _storage.write(key: _userLatitudeKey, value: latitude.toString());
    } catch (e) {
      print('خطأ في حفظ خط العرض: $e');
    }
  }

  /// استرجاع خط العرض للمستخدم
  Future<double?> getUserLatitude() async {
    try {
      String? latitudeStr = await _storage.read(key: _userLatitudeKey);
      if (latitudeStr != null) {
        return double.tryParse(latitudeStr);
      }
      return null;
    } catch (e) {
      print('خطأ في استرجاع خط العرض: $e');
      return null;
    }
  }

  /// حفظ خط الطول للمستخدم
  Future<void> saveUserLongitude(double longitude) async {
    try {
      await _storage.write(key: _userLongitudeKey, value: longitude.toString());
    } catch (e) {
      print('خطأ في حفظ خط الطول: $e');
    }
  }

  /// استرجاع خط الطول للمستخدم
  Future<double?> getUserLongitude() async {
    try {
      String? longitudeStr = await _storage.read(key: _userLongitudeKey);
      if (longitudeStr != null) {
        return double.tryParse(longitudeStr);
      }
      return null;
    } catch (e) {
      print('خطأ في استرجاع خط الطول: $e');
      return null;
    }
  }

  /// حفظ اسم الموقع
  Future<void> saveUserLocationName(String locationName) async {
    try {
      await _storage.write(key: _userLocationNameKey, value: locationName);
    } catch (e) {
      print('خطأ في حفظ اسم الموقع: $e');
    }
  }

  /// استرجاع اسم الموقع
  Future<String?> getUserLocationName() async {
    try {
      return await _storage.read(key: _userLocationNameKey);
    } catch (e) {
      print('خطأ في استرجاع اسم الموقع: $e');
      return null;
    }
  }

  /// حفظ الموقع الكامل (الإحداثيات والعنوان واسم الموقع)
  Future<void> saveUserLocation({
    required double latitude,
    required double longitude,
    String? address,
    String? locationName,
  }) async {
    try {
      await Future.wait([
        saveUserLatitude(latitude),
        saveUserLongitude(longitude),
        if (address != null) saveUserAddress(address),
        if (locationName != null) saveUserLocationName(locationName),
      ]);
    } catch (e) {
      print('خطأ في حفظ الموقع الكامل: $e');
    }
  }

  /// استرجاع الموقع الكامل
  Future<UserLocationData?> getUserLocation() async {
    try {
      final results = await Future.wait([
        getUserLatitude(),
        getUserLongitude(),
        getUserAddress(),
        getUserLocationName(),
      ]);

      double? latitude = results[0] as double?;
      double? longitude = results[1] as double?;
      String? address = results[2] as String?;
      String? locationName = results[3] as String?;

      if (latitude != null && longitude != null) {
        return UserLocationData(
          latitude: latitude,
          longitude: longitude,
          address: address,
          locationName: locationName,
        );
      }
      return null;
    } catch (e) {
      print('خطأ في استرجاع الموقع الكامل: $e');
      return null;
    }
  }

  /// مسح جميع بيانات الموقع
  Future<void> clearUserLocation() async {
    try {
      await Future.wait([
        _storage.delete(key: _userAddressKey),
        _storage.delete(key: _userLatitudeKey),
        _storage.delete(key: _userLongitudeKey),
        _storage.delete(key: _userLocationNameKey),
      ]);
    } catch (e) {
      print('خطأ في مسح بيانات الموقع: $e');
    }
  }

  /// التحقق من وجود بيانات موقع محفوظة
  Future<bool> hasUserLocation() async {
    try {
      double? latitude = await getUserLatitude();
      double? longitude = await getUserLongitude();
      return latitude != null && longitude != null;
    } catch (e) {
      print('خطأ في التحقق من وجود بيانات الموقع: $e');
      return false;
    }
  }
}

/// فئة لتمثيل بيانات موقع المستخدم
class UserLocationData {
  final double latitude;
  final double longitude;
  final String? address;
  final String? locationName;

  UserLocationData({
    required this.latitude,
    required this.longitude,
    this.address,
    this.locationName,
  });

  @override
  String toString() {
    return 'UserLocationData(lat: $latitude, lng: $longitude, address: $address, name: $locationName)';
  }
}

