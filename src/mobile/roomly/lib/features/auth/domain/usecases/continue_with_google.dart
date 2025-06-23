import '../entities/google_user_entity.dart';
import '../repositories/auth_repository.dart';

class ContinueWithGoogleUseCase {
  final AuthRepository repository;

  ContinueWithGoogleUseCase({required this.repository});

  Future<Map<String, dynamic>> call(GoogleUserEntity googleUserEntity) async {
    return await repository.continueWithGoogle(googleUserEntity);
  }
}
