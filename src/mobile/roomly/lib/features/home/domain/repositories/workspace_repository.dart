
import 'package:dartz/dartz.dart';
import '../../../room_management/data/models/room_model.dart';
import '../../data/data_sources/failure.dart';
import '../entities/workspace.dart';

abstract class WorkspaceRepository {
  Future<Either<Failure, List<Workspace>>> getNearbyWorkspaces({
    required String userId,
    required double latitude,
    required double longitude,
    int topN = 5,
  });

  Future<Either<Failure, List<Workspace>>> getTopRatedWorkspaces({
    required String userId,
    int topN = 5,
  });

  Future<Either<Failure, Workspace>> getWorkspaceDetails({
    required String workspaceId,
  });

  Future<Either<Failure, List<String>>> getWorkspaceImages({
    required String workspaceId,
  });


}

