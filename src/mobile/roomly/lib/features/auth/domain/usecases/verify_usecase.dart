
import '../repositories/auth_repository.dart';

class VerifyUserUseCase {
  final AuthRepository repository;

  VerifyUserUseCase({required this.repository});

  Future<Map<String, dynamic>> call(int otp) async {
    return await repository.verifyUser(otp);
  }
}