import 'package:dartz/dartz.dart';
import '../../data/data_sources/failure.dart';
import '../entities/workspace.dart';
import '../repositories/workspace_repository.dart';

// workspace_usecases.dart
import 'package:dartz/dartz.dart';
import '../../data/data_sources/failure.dart';
import '../entities/workspace.dart';
import '../repositories/workspace_repository.dart';

import 'package:dartz/dartz.dart';
import '../../data/data_sources/failure.dart';
import '../entities/workspace.dart';
import '../repositories/workspace_repository.dart';

class WorkspaceUseCases {
  final GetWorkspaceDetails getWorkspaceDetails;
  final GetWorkspaceImages getWorkspaceImages;

  WorkspaceUseCases({
    required this.getWorkspaceDetails,
    required this.getWorkspaceImages,
  });
}

class GetWorkspaceDetails {
  final WorkspaceRepository repository;

  const GetWorkspaceDetails(this.repository);

  Future<Either<Failure, Workspace>> call(String workspaceId) async {
    try {
      return await repository.getWorkspaceDetails(workspaceId: workspaceId);
    } catch (e) {
      return Left(ServerFailure('Failed to get workspace details: ${e.toString()}'));
    }
  }
}

class GetWorkspaceImages {
  final WorkspaceRepository repository;

  const GetWorkspaceImages(this.repository);

  Future<Either<Failure, List<String>>> call(String workspaceId) async {
    try {
      return await repository.getWorkspaceImages(workspaceId: workspaceId);
    } catch (e) {
      return Left(ServerFailure('Failed to get workspace images: ${e.toString()}'));
    }
  }
}


class GetNearbyWorkspaces {
  final WorkspaceRepository repository;

  const GetNearbyWorkspaces(this.repository);

  Future<Either<Failure, List<Workspace>>> call({
    required String userId,
    required double latitude,
    required double longitude,
    int topN = 10,
  }) async {
    try {
      return await repository.getNearbyWorkspaces(
        userId: userId,
        latitude: latitude,
        longitude: longitude,
        topN: topN,
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get nearby workspaces: ${e.toString()}'));
    }
  }
}

class GetTopRatedWorkspaces {
  final WorkspaceRepository repository;

  const GetTopRatedWorkspaces(this.repository);

  Future<Either<Failure, List<Workspace>>> call({
    required String userId,
    int topN = 10,
  }) async {
    try {
      return await repository.getTopRatedWorkspaces(
        userId: userId,
        topN: topN,
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get top rated workspaces: ${e.toString()}'));
    }
  }
}

