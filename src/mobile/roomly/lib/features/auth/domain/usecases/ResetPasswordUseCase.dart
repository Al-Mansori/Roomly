import '../repositories/auth_repository.dart';

class SendForgotPasswordOtpUseCase {
  final AuthRepository repository;

  SendForgotPasswordOtpUseCase(this.repository);

  Future<Map<String, dynamic>> call(String email) async {
    return await repository.sendForgotPasswordOtp(email);
  }
}

class VerifyResetOtpUseCase {
  final AuthRepository repository;

  VerifyResetOtpUseCase(this.repository);

  Future<Map<String, dynamic>> call(String email, int otp) async {
    return await repository.verifyResetOtp(email, otp);
  }
}

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase({required this.repository});

  Future<Map<String, dynamic>> call(String email, String newPassword) async {
    return await repository.resetPassword(email, newPassword);
  }
}