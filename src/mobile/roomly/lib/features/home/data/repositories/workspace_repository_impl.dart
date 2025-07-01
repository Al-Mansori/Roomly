import 'package:dartz/dartz.dart';
import '../../domain/entities/workspace.dart';
import '../../domain/repositories/workspace_repository.dart';
import '../data_sources/failure.dart';
import '../data_sources/workspace_remote_datasource.dart';
import '../models/workspace_model.dart';


class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final WorkspaceRemoteDataSource remoteDataSource;

  WorkspaceRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Workspace>>> getNearbyWorkspaces({
    required String userId,
    required double latitude,
    required double longitude,
    int topN = 5,
  }) async {
    try {
      final workspaces = await remoteDataSource.getNearbyWorkspaces(
        userId: userId,
        latitude: latitude,
        longitude: longitude,
        topN: topN,
      );
      print("Raw Response: ${workspaces}");

      // Convert to WorkspaceModel list and ensure proper typing
      final workspaceModels = workspaces.map((w) => w as WorkspaceModel).toList();
      print("Raw Response after : ${workspaceModels}");

      // Save to local cache

      return Right(workspaceModels);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch nearby workspaces: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Workspace>>> getTopRatedWorkspaces({
    required String userId,
    int topN = 5,
  }) async {
    try {
      final workspaces = await remoteDataSource.getTopRatedWorkspaces(
        userId: userId,
        topN: topN,
      );
      print("getTopRatedWorkspaces Raw Response: ${workspaces}");

      final workspaceModels = workspaces.map((w) => w as WorkspaceModel).toList();
      print("Raw Response getTopRatedWorkspaces : ${workspaceModels}");


      return Right(workspaceModels);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch top rated workspaces: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Workspace>> getWorkspaceDetails({
    required String workspaceId,
  }) async {
    try {
      final workspace = await remoteDataSource.getWorkspaceDetails(
        workspaceId: workspaceId,
      );

      return Right(workspace);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch workspace details: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getWorkspaceImages({
    required String workspaceId,
  }) async {
    try {
      final images = await remoteDataSource.getWorkspaceImages(
        workspaceId: workspaceId, // Add the workspaceId parameter here
      );
      return Right(images);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch workspace images: ${e.toString()}'));
    }
  }



}

