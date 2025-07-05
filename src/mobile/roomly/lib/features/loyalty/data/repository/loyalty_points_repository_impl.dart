// import 'package:dartz/dartz.dart';
// import '../../domain/entities/loyalty_points_entity.dart';
// import '../../domain/repository/loyalty_points_repository.dart';
// import '../../data/data_source/loyalty_points_remote_data_source.dart';
// import '../models/loyalty_points_model.dart';
// import '../../../../core/error/failures.dart';
// import '../../../../core/error/exceptions.dart';
// import '../../../../core/network/network_info.dart';

// // Repository Implementation (Data Layer)
// class LoyaltyPointsRepositoryImpl implements LoyaltyPointsRepository {
//   final LoyaltyPointsRemoteDataSource remoteDataSource;
//   final NetworkInfo networkInfo;

//   LoyaltyPointsRepositoryImpl({
//     required this.remoteDataSource,
//     required this.networkInfo,
//   });

//   @override
//   Future<Either<Failure, LoyaltyPointsEntity>> getLoyaltyPoints(String userId) async {
//     if (await networkInfo.isConnected) {
//       try {
//         final remoteLoyaltyPoints = await remoteDataSource.getLoyaltyPoints(userId);
//         return Right(remoteLoyaltyPoints.toEntity());
//       } on ServerException {
//         return const Left(ServerFailure(message: 'Server error occurred'));
//       } on NoDataException catch (e) {
//         return Left(NoDataFailure(message: e.message));
//       } catch (e) {
//         return Left(ServerFailure(message: e.toString()));
//       }
//     } else {
//       return const Left(NetworkFailure(message: 'No internet connection'));
//     }
//   }

//   @override
//   Future<Either<Failure, LoyaltyPointsEntity>> updateLoyaltyPoints(LoyaltyPointsEntity loyaltyPoints) async {
//     if (await networkInfo.isConnected) {
//       try {
//         final loyaltyPointsModel = LoyaltyPointsModel.fromEntity(loyaltyPoints);
//         final updatedLoyaltyPoints = await remoteDataSource.updateLoyaltyPoints(loyaltyPointsModel);
//         return Right(updatedLoyaltyPoints.toEntity());
//       } on ServerException {
//         return const Left(ServerFailure(message: 'Server error occurred'));
//       } catch (e) {
//         return Left(ServerFailure(message: e.toString()));
//       }
//     } else {
//       return const Left(NetworkFailure(message: 'No internet connection'));
//     }
//   }

//   @override
//   Future<Either<Failure, bool>> addPoints(String userId, int points) async {
//     if (await networkInfo.isConnected) {
//       try {
//         final result = await remoteDataSource.addPoints(userId, points);
//         return Right(result);
//       } on ServerException {
//         return const Left(ServerFailure(message: 'Server error occurred'));
//       } catch (e) {
//         return Left(ServerFailure(message: e.toString()));
//       }
//     } else {
//       return const Left(NetworkFailure(message: 'No internet connection'));
//     }
//   }

//   @override
//   Future<Either<Failure, bool>> redeemPoints(String userId, int points) async {
//     if (await networkInfo.isConnected) {
//       try {
//         final result = await remoteDataSource.redeemPoints(userId, points);
//         return Right(result);
//       } on ServerException {
//         return const Left(ServerFailure(message: 'Server error occurred'));
//       } catch (e) {
//         return Left(ServerFailure(message: e.toString()));
//       }
//     } else {
//       return const Left(NetworkFailure(message: 'No internet connection'));
//     }
//   }
// }



// v2 ==============================================================================


import 'package:dartz/dartz.dart';
import 'package:roomly/features/loyalty/domain/entities/room_loyalty_entity.dart';
import '../../domain/entities/loyalty_points_entity.dart';
import '../../domain/repository/loyalty_points_repository.dart';
import '../../data/data_source/loyalty_points_remote_data_source.dart';
import '../models/loyalty_points_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';

// Repository Implementation (Data Layer)
class LoyaltyPointsRepositoryImpl implements LoyaltyPointsRepository {
  final LoyaltyPointsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  LoyaltyPointsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, LoyaltyPointsEntity>> getLoyaltyPoints(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLoyaltyPoints = await remoteDataSource.getLoyaltyPoints(userId);
        return Right(remoteLoyaltyPoints.toEntity());
      } on ServerException {
        return const Left(ServerFailure(message: 'Server error occurred'));
      } on NoDataException catch (e) {
        return Left(NoDataFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, LoyaltyPointsEntity>> updateLoyaltyPoints(LoyaltyPointsEntity loyaltyPoints) async {
    if (await networkInfo.isConnected) {
      try {
        final loyaltyPointsModel = LoyaltyPointsModel.fromEntity(loyaltyPoints);
        final updatedLoyaltyPoints = await remoteDataSource.updateLoyaltyPoints(loyaltyPointsModel);
        return Right(updatedLoyaltyPoints.toEntity());
      } on ServerException {
        return const Left(ServerFailure(message: 'Server error occurred'));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> addPoints(String userId, int points) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.addPoints(userId, points);
        return Right(result);
      } on ServerException {
        return const Left(ServerFailure(message: 'Server error occurred'));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> redeemPoints(String userId, int points) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.redeemPoints(userId, points);
        return Right(result);
      } on ServerException {
        return const Left(ServerFailure(message: 'Server error occurred'));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<TopRoomEntity>>> getTopRooms() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTopRooms = await remoteDataSource.getTopRooms();
        return Right(remoteTopRooms.map((model) => model.toEntity()).toList());
      } on ServerException {
        return const Left(ServerFailure(message: 'Server error occurred'));
      } on NoDataException catch (e) {
        return Left(NoDataFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}


