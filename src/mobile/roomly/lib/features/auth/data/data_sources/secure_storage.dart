import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:roomly/features/auth/data/models/user_model.dart';

class SecureStorage {
  static const _tokenKey = 'auth_token';
  static const _userId = 'user_id';
  static const _userData = 'user_data';
  static const _refreshTokenKey = 'refresh_token';
  static const _userEmailKey = 'user_email';

  static final _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }
  static Future<void> saveId(UserModel user) async {
    await _storage.write(key: _userId, value: user.id);
  }

  static Future<void> saveUserData(UserModel user) async {
    await _storage.write(key: _userData, value: jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getUserData() async {
    final data = await _storage.read(key: _userData);
    if (data != null) {
      return UserModel.fromJson(jsonDecode(data));
    }
    return null;
  }

  static Future<String?> getId() async {
    return await _storage.read(key: _userId);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  static Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _userEmailKey, value: email);
  }

  static Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }


}