import 'package:dartz/dartz.dart';
import 'package:roomly/features/auth/data/models/user_model.dart';
import 'package:roomly/features/auth/domain/entities/user_entity.dart';
import 'package:roomly/features/profile/data/data_source/user_local_data_source.dart';
import 'package:roomly/features/profile/data/data_source/user_remote_data_source.dart';
import 'package:roomly/features/profile/domain/repository/user_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> getCachedUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser.toEntity());
      } else {
        return Left(CacheFailure(message: 'No user data found in cache'));
      }
    } on CacheException {
      return Left(CacheFailure(message: 'Failed to retrieve user from cache'));
    }
  }

  @override
  Future<Either<Failure, String>> updateUser(UserEntity user) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = UserModel(
          id: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          password: user.password,
          phone: user.phone,
          address: user.address,
          isStaff: user.isStaff,
        );

        final result = await remoteDataSource.updateUser(userModel);
        
        // Update local cache with the updated user data
        await localDataSource.cacheUser(userModel);
        
        return Right(result);
      } on ServerException {
        return Left(ServerFailure(message: 'Failed to update user'));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> deleteUser(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.deleteUser(userId);
        
        // Clear local cache after successful deletion
        await localDataSource.clearUserData();
        
        return Right(result);
      } on ServerException {
        return Left(ServerFailure(message: 'Failed to delete user'));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}

