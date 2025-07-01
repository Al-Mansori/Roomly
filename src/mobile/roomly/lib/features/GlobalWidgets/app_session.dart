import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../auth/domain/entities/user_entity.dart';

class AppSession {
  static final AppSession _instance = AppSession._internal();
  factory AppSession() => _instance;
  AppSession._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  UserEntity? _currentUser;
  String? _token;

  /// Getters
  UserEntity? get currentUser => _currentUser;
  String? get token => _token;

  /// Setters
  void setUser(UserEntity user) {
    _currentUser = user;
  }

  void clearUser() {
    _currentUser = null;
  }

  Future<void> setToken(String token) async {
    _token = token;
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<void> loadToken() async {
    _token = await _storage.read(key: 'auth_token');
  }
  Future<void> clearSession() async {
    clearUser(); // Clears _currentUser
    await clearToken(); // Clears auth_token from secure storage
  }

  Future<void> clearToken() async {
    _token = null;
    await _storage.delete(key: 'auth_token');
  }

  /// Convenience
  String? get userId => _currentUser?.id;
  String? get email => _currentUser?.email;
  String? get fullName => _currentUser?.firstName != null && _currentUser?.lastName != null
      ? '${_currentUser?.firstName} ${_currentUser?.lastName}'
      : null;
  String? get phone => _currentUser?.phone;
  String? get address => _currentUser?.address;
  bool? get isStaff => _currentUser?.isStaff;
}
