import '../entities/login_request_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<Map<String, dynamic>> call(LoginRequestEntity loginRequest) async {
    return await repository.login(loginRequest);
  }
}
