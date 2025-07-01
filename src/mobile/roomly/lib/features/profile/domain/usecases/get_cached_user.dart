import 'package:dartz/dartz.dart';
import 'package:roomly/features/auth/domain/entities/user_entity.dart';
import 'package:roomly/features/profile/domain/repository/user_repository.dart';
import '../../../../core/error/failures.dart';

class GetCachedUser {
  final UserRepository repository;

  GetCachedUser(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getCachedUser();
  }
}

