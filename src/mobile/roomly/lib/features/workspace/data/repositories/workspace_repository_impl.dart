// import 'package:dartz/dartz.dart';
// import 'package:roomly/core/error/exceptions.dart';
// import 'package:roomly/features/workspace/data/data_sources/workspace_remote_data_source.dart';
// import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
// import 'package:roomly/features/workspace/domain/entities/workspace_entity.dart';
// import 'package:roomly/features/workspace/domain/repositories/workspace_repository.dart';
// import 'package:roomly/core/error/failures.dart';

// class WorkspaceRepositoryImpl implements WorkspaceRepository {
//   final WorkspaceRemoteDataSource remoteDataSource;

//   WorkspaceRepositoryImpl({required this.remoteDataSource});

//   @override
//   Future<Either<Failure, WorkspaceEntity>> getWorkspaceDetails(String workspaceId) async {
//     try {
//       final remoteWorkspace = await remoteDataSource.getWorkspaceDetails(workspaceId);
//       return Right(remoteWorkspace);
//     } on ServerException {
//       return Left(ServerFailure(message: 'Failed to fetch workspace details'));
//     }
//   }

//   @override
//   Future<Either<Failure, RoomEntity>> getRoomDetails(String roomId) async {
//     try {
//       final remoteRoom = await remoteDataSource.getRoomDetails(roomId);
//       return Right(remoteRoom as RoomEntity);
//     } on ServerException {
//       return Left(ServerFailure(message: 'Failed to fetch room details'));
//     }
//   }
// }


// v2 ----------------------------------------------------------------------------



import 'package:dartz/dartz.dart';
import 'package:roomly/core/error/exceptions.dart';
import 'package:roomly/features/workspace/data/data_sources/workspace_remote_data_source.dart';
import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
import 'package:roomly/features/workspace/domain/entities/review_entity.dart';
import 'package:roomly/features/workspace/domain/entities/user_entity_workspace.dart';
import 'package:roomly/features/workspace/domain/entities/workspace_entity.dart';
import 'package:roomly/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:roomly/core/error/failures.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final WorkspaceRemoteDataSource remoteDataSource;

  WorkspaceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, WorkspaceEntity>> getWorkspaceDetails(String workspaceId) async {
    try {
      final remoteWorkspace = await remoteDataSource.getWorkspaceDetails(workspaceId);
      return Right(remoteWorkspace);
    } on ServerException {
      return Left(ServerFailure(message: 'Failed to fetch workspace details'));
    }
  }

  @override
  Future<Either<Failure, RoomEntity>> getRoomDetails(String roomId) async {
    try {
      final remoteRoom = await remoteDataSource.getRoomDetails(roomId);
      return Right(remoteRoom as RoomEntity);
    } on ServerException {
      return Left(ServerFailure(message: 'Failed to fetch room details'));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getWorkspaceReviews(String workspaceId) async {
    try {
      final reviews = await remoteDataSource.getWorkspaceReviews(workspaceId);
      return Right(reviews);
    } on ServerException {
      return Left(ServerFailure(message: 'Failed to fetch workspace reviews'));
    }
  }

  @override
  Future<Either<Failure, UserEntity2>> getUserName(String userId) async {
    try {
      final userName = await remoteDataSource.getUserName(userId);
      return Right(userName);
    } on ServerException {
      return Left(ServerFailure(message: 'Failed to fetch user name'));
    }
  }


  @override
  Future<Either<Failure, void>> submitReview({required String comment, required String userId, required String workspaceId, required double rating}) async {
    try {
      await remoteDataSource.submitReview(comment: comment, userId: userId, workspaceId: workspaceId, rating: rating);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure(message: 'Failed to submit review'));
    }
  }

}



  



