import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:roomly/features/auth/data/models/user_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/app_api.dart';

abstract class UserRemoteDataSource {
  Future<String> updateUser(UserModel user);
  Future<String> deleteUser(String userId);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<String> updateUser(UserModel user) async {
    try {
      // Add the required "type" field for the API request
      final requestBody = user.toJson();
      requestBody['type'] = 'CUSTOMER';
      // Removed the line: requestBody['password'] = user.password ?? '';
      // The password is now included in user.toJson() if it exists

      final response = await client.put(
        Uri.parse('${AppApi.baseUrl}/api/users/update-user'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<String> deleteUser(String userId) async {
    try {
      final response = await client.delete(
        Uri.parse('${AppApi.baseUrl}/api/users/delete?id=$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}


