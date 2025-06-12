import 'package:dartz/dartz.dart';
import 'package:roomly/features/auth/domain/entities/user_entity.dart';
import '../../../../core/error/failures.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getCachedUser();
  Future<Either<Failure, String>> updateUser(UserEntity user);
  Future<Either<Failure, String>> deleteUser(String userId);
}

