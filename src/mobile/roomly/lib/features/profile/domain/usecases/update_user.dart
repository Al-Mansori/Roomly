import 'package:dartz/dartz.dart';
import 'package:roomly/features/auth/domain/entities/user_entity.dart';
import 'package:roomly/features/profile/domain/repository/user_repository.dart';
import '../../../../core/error/failures.dart';

class UpdateUser {
  final UserRepository repository;

  UpdateUser(this.repository);

  Future<Either<Failure, String>> call(UserEntity user) async {
    return await repository.updateUser(user);
  }
}

