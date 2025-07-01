import 'package:dartz/dartz.dart';
import '../../data/data_sources/failure.dart';
import '../entities/workspace.dart';
import '../repositories/workspace_repository.dart';

class GetNearbyWorkspacesUseCase {
  final WorkspaceRepository repository;

  GetNearbyWorkspacesUseCase(this.repository);

  Future<Either<Failure, List<Workspace>>> call(
      GetNearbyWorkspacesParams params,
      ) async {
    return await repository.getNearbyWorkspaces(
      userId: params.userId,
      latitude: params.latitude,
      longitude: params.longitude,
      topN: params.topN,
    );
  }
}

class GetNearbyWorkspacesParams {
  final String userId;
  final double latitude;
  final double longitude;
  final int topN;

  GetNearbyWorkspacesParams({
    required this.userId,
    required this.latitude,
    required this.longitude,
    this.topN = 5,
  });
}

