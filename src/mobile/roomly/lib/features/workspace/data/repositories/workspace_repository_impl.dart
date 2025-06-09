import 'package:dartz/dartz.dart';
import 'package:roomly/core/error/exceptions.dart';
import 'package:roomly/features/workspace/data/data_sources/workspace_remote_data_source.dart';
import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
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
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, RoomEntity>> getRoomDetails(String roomId) async {
    try {
      final remoteRoom = await remoteDataSource.getRoomDetails(roomId);
      return Right(remoteRoom as RoomEntity);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}


