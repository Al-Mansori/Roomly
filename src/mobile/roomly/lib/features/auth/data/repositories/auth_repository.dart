import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/entities/login_request_entity.dart';
import '../../domain/entities/registration_request_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/user_model.dart';
import '../models/google_user_model.dart';
import '../../domain/entities/google_user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> login(LoginRequestEntity loginRequest) async {
    try {
      final response = await remoteDataSource.login(loginRequest);

      // Ensure the user field is properly converted to Map if needed
      final user = response['user'] is UserModel
          ? (response['user'] as UserModel).toJson()
          : response['user'];

      return {
        'user': user,
        'token': response['token'],
      };
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> resetPassword(
      String email, String newPassword) async {
    return await remoteDataSource.resetPassword(email, newPassword);
  }

  @override
  Future<Map<String, dynamic>> registerCustomer(
      RegistrationRequestEntity registrationRequest) async {
    return await remoteDataSource.registerCustomer(registrationRequest);
  }

  @override
  Future<Map<String, dynamic>> registerStaff(
      RegistrationRequestEntity registrationRequest) async {
    return await remoteDataSource.registerStaff(registrationRequest);
  }

  @override
  Future<Map<String, dynamic>> verifyUser(int otp) async {
    return await remoteDataSource.verifyUser(otp);
  }

  @override
  Future<Map<String, dynamic>> completeProfile(
      Map<String, dynamic> profileData) async {
    return await remoteDataSource.completeProfile(profileData);
  }

  @override
  Future<Map<String, dynamic>> sendForgotPasswordOtp(String email) async {
    return await remoteDataSource.sendForgotPasswordOtp(email);
  }

  @override
  Future<Map<String, dynamic>> verifyResetOtp(String email, int otp) async {
    return await remoteDataSource.verifyResetOtp(email, otp);
  }

  @override
  Future<Map<String, dynamic>> continueWithGoogle(
      GoogleUserEntity googleUserEntity) {
    return remoteDataSource.continueWithGoogle(GoogleUserModel(
      id: googleUserEntity.id,
      email: googleUserEntity.email,
      firstName: googleUserEntity.firstName,
      lastName: googleUserEntity.lastName,
    ));
  }
}
