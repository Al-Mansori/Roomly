import 'package:dartz/dartz.dart';
import 'package:roomly/features/profile/domain/repository/user_repository.dart';
import '../../../../core/error/failures.dart';

class DeleteUser {
  final UserRepository repository;

  DeleteUser(this.repository);

  Future<Either<Failure, String>> call(String userId) async {
    return await repository.deleteUser(userId);
  }
}

