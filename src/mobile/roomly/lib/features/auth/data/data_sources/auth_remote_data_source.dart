import 'dart:convert';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:roomly/features/GlobalWidgets/app_session.dart';
import 'package:roomly/features/auth/data/models/google_user_model.dart';

import '../../../../core/network/app_api.dart';
import '../../domain/entities/login_request_entity.dart';
import '../../domain/entities/registration_request_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../models/login_request_model.dart';
import '../models/registration_request_model.dart';
import '../models/user_model.dart';
import '../../domain/entities/google_user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(LoginRequestEntity loginRequest);
  Future<Map<String, dynamic>> registerCustomer(
      RegistrationRequestEntity registrationRequest);
  Future<Map<String, dynamic>> registerStaff(
      RegistrationRequestEntity registrationRequest);
  Future<Map<String, dynamic>> verifyUser(int otp);
  Future<Map<String, dynamic>> completeProfile(
      Map<String, dynamic> profileData);
  Future<Map<String, dynamic>> resetPassword(String email, String newPassword);
  Future<Map<String, dynamic>> sendForgotPasswordOtp(String email);
  Future<Map<String, dynamic>> verifyResetOtp(String email, int otp);
  Future<Map<String, dynamic>> continueWithGoogle(
      GoogleUserModel googleUserModel);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> login(LoginRequestEntity loginRequest) async {
    try {
      final response = await client.post(
        Uri.parse('${AppApi.baseUrl}/api/users/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(LoginRequestModel(
          email: loginRequest.email,
          password: loginRequest.password,
          isStaff: loginRequest.isStaff,
        ).toJson()),
      );

      final jsonResponse = jsonDecode(response.body);

      // Debug print - remove in production
      print('Login response: ${response.statusCode} - $jsonResponse');

      if (response.statusCode == 200) {
        // Handle successful login
        if (jsonResponse['user'] != null && jsonResponse['token'] != null) {
          AppSession().setToken(jsonResponse['token']);
          final userModel = UserModel.fromJson(jsonResponse['user']);
          AppSession().setUser(userModel);

          return {
            'user': UserModel.fromJson(jsonResponse['user']),
            'token': jsonResponse['token'],
          };
        }
        // Handle wrong credentials
        else if (jsonResponse['error'] != null) {
          throw Exception(jsonResponse['error']);
        }
        // Handle malformed response
        else {
          throw const FormatException('Invalid server response format');
        }
      } else {
        // Handle other status codes
        final errorMsg = jsonResponse['error'] ??
            'Login failed (Status: ${response.statusCode})';
        throw Exception(errorMsg);
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException catch (e) {
      throw Exception('Invalid server response: ${e.message}');
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> registerCustomer(
      RegistrationRequestEntity registrationRequest) async {
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
  Future<Map<String, dynamic>> registerStaff(
      RegistrationRequestEntity registrationRequest) async {
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
    final userId = AppSession().currentUser?.id;

    final completeData = {
      'id': userId,
      ...profileData,
    };

    final response = await client.post(
      Uri.parse('${AppApi.baseUrl}/api/users/auth/complete-profile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(completeData),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // Update the session with the new user data
      final user = UserEntity.fromJson(responseData['user']); // Adjust based on your API response structure
      AppSession().setUser(user);

      return responseData;
    } else {
      throw Exception('Failed to complete profile: ${response.statusCode}');
    }
  }
  @override
  Future<Map<String, dynamic>> sendForgotPasswordOtp(String email) async {
    try {
      final response = await client.post(
        Uri.parse('${AppApi.baseUrl}/api/users/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'status': jsonResponse['status'],
          'message': jsonResponse['message'] ?? jsonResponse['error'],
        };
      } else {
        throw Exception(jsonResponse['error'] ?? 'Failed to send OTP');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to send OTP: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> verifyResetOtp(String email, int otp) async {
    try {
      final response = await client.post(
        Uri.parse('${AppApi.baseUrl}/api/users/auth/verify-reset-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'otp': otp,
        }),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'status': jsonResponse['status'],
          'message': jsonResponse['message'] ?? jsonResponse['error'],
        };
      } else {
        throw Exception(jsonResponse['error'] ?? 'OTP verification failed');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('OTP verification failed: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> resetPassword(
      String email, String newPassword) async {
    final response = await client.post(
      Uri.parse('${AppApi.baseUrl}/api/users/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to reset password: ${response.statusCode}');
    }
  }

  @override
  Future<Map<String, dynamic>> continueWithGoogle(
      GoogleUserModel googleUserModel) async {
    try {
      final response = await client.post(
        Uri.parse('${AppApi.baseUrl}/api/users/auth/continue-google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(GoogleUserModel(
          id: googleUserModel.id,
          email: googleUserModel.email,
          firstName: googleUserModel.firstName,
          lastName: googleUserModel.lastName,
        ).toJson()),
      );

      final jsonResponse = jsonDecode(response.body);

      // Debug print - remove in production
      print('google register response: ${response.statusCode} - $jsonResponse');

      if (response.statusCode == 200) {
        if (jsonResponse['user'] != null && jsonResponse['token'] != null) {
          AppSession().setToken(jsonResponse['token']);
          // final googleUserModel =
          //     GoogleUserModel.fromJson(jsonResponse['user']);
          final userModel = UserModel.fromJson(jsonResponse['user']);
          // final userModel = UserModel(
          //   id: googleUserModel.id,
          //   email: googleUserModel.email,
          //   firstName: googleUserModel.firstName,
          //   lastName: googleUserModel.lastName,
          //   phone: '',
          //   address: '',
          // );
          AppSession().setUser(userModel);
          return {
            'user': userModel.toJson(),
            'token': jsonResponse['token'],
          };
        }
        // Handle wrong credentials
        else if (jsonResponse['error'] != null) {
          throw Exception(jsonResponse['error']);
        }
        // Handle malformed response
        else {
          throw const FormatException('Invalid server response format');
        }
      } else {
        // Handle other status codes
        final errorMsg = jsonResponse['error'] ??
            'Login failed (Status: ${response.statusCode})';
        throw Exception(errorMsg);
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException catch (e) {
      throw Exception('Invalid server response: ${e.message}');
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }
}
