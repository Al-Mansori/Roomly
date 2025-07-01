import 'package:roomly/features/auth/data/data_sources/secure_storage.dart';
import 'package:roomly/features/auth/data/models/user_model.dart';


abstract class UserLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearUserData();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  @override
  Future<UserModel?> getCachedUser() async {
    return await SecureStorage.getUserData();
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await SecureStorage.saveUserData(user);
  }

  @override
  Future<void> clearUserData() async {
    await SecureStorage.clearAll();
  }
}

