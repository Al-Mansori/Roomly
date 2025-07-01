
import '../entities/registration_request_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterCustomerUseCase {
  final AuthRepository repository;

  RegisterCustomerUseCase({required this.repository});

  Future<Map<String, dynamic>> call(RegistrationRequestEntity registrationRequest) async {
    return await repository.registerCustomer(registrationRequest);
  }
}