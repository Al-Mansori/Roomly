import 'package:roomly/features/auth/domain/entities/google_user_entity.dart';

import '../entities/login_request_entity.dart';
import '../entities/registration_request_entity.dart';

abstract class AuthRepository {
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
      GoogleUserEntity googleUserEntity);
}
