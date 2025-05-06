import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/network/app_api.dart';
import '../../domain/entities/login_request_entity.dart';
import '../../domain/entities/registration_request_entity.dart';
import '../models/login_request_model.dart';
import '../models/registration_request_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(LoginRequestEntity loginRequest);
  Future<Map<String, dynamic>> registerCustomer(RegistrationRequestEntity registrationRequest);
  Future<Map<String, dynamic>> registerStaff(RegistrationRequestEntity registrationRequest);
  Future<Map<String, dynamic>> verifyUser(int otp);
  Future<Map<String, dynamic>> completeProfile(Map<String, dynamic> profileData);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> login(LoginRequestEntity loginRequest) async {
    final response = await client.post(
      Uri.parse('${AppApi.baseUrl}/api/users/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(LoginRequestModel(
        email: loginRequest.email,
        password: loginRequest.password,
        isStaff: loginRequest.isStaff,
      ).toJson()),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['user'] != null) {
        return {
          'user': UserModel.fromJson(jsonResponse['user']),
          'token': jsonResponse['token'],
        };
      } else {
        throw Exception(jsonResponse['error'] ?? 'Login failed');
      }
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  @override
  Future<Map<String, dynamic>> registerCustomer(RegistrationRequestEntity registrationRequest) async {
    final response = await client.post(
      Uri.parse('${AppApi.baseUrl}/api/users/auth/register-customer'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': registrationRequest.email,
        'password': registrationRequest.password,
        'confirmPassword': registrationRequest.confirmPassword,
        'isStaff': registrationRequest.isStaff,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register customer: ${response.statusCode}');
    }
  }

  @override
  Future<Map<String, dynamic>> registerStaff(RegistrationRequestEntity registrationRequest) async {
    final response = await client.post(
      Uri.parse('${AppApi.baseUrl}/api/users/auth/register-staff'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(RegistrationRequestModel(
        firstName: registrationRequest.firstName,
        lastName: registrationRequest.lastName,
        email: registrationRequest.email,
        password: registrationRequest.password,
        confirmPassword: registrationRequest.confirmPassword,
        phone: registrationRequest.phone,
        isStaff: registrationRequest.isStaff,
      ).toJson()),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register staff: ${response.statusCode}');
    }
  }

  @override
  Future<Map<String, dynamic>> verifyUser(int otp) async {
    final response = await client.post(
      Uri.parse('${AppApi.baseUrl}/api/users/auth/verify?otp=$otp'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to verify user: ${response.statusCode}');
    }
  }

  @override
  Future<Map<String, dynamic>> completeProfile(Map<String, dynamic> profileData) async {
    final response = await client.post(
      Uri.parse('${AppApi.baseUrl}/api/users/auth/complete-profile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profileData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to complete profile: ${response.statusCode}');
    }
  }
}

