
import '../entities/registration_request_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterStaffUseCase {
  final AuthRepository repository;

  RegisterStaffUseCase({required this.repository});

  Future<Map<String, dynamic>> call(RegistrationRequestEntity registrationRequest) async {
    return await repository.registerStaff(registrationRequest);
  }
}