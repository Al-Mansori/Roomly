
import '../repositories/auth_repository.dart';

class CompleteProfileUseCase {
  final AuthRepository repository;

  CompleteProfileUseCase({required this.repository});

  Future<Map<String, dynamic>> call(Map<String, dynamic> profileData) async {
    return await repository.completeProfile(profileData);
  }
}