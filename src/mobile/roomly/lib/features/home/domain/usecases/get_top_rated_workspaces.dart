import 'package:dartz/dartz.dart';
import '../../data/data_sources/failure.dart';
import '../entities/workspace.dart';
import '../repositories/workspace_repository.dart';

class GetTopRatedWorkspacesUseCase {
  final WorkspaceRepository repository;

  GetTopRatedWorkspacesUseCase(this.repository);

  Future<Either<Failure, List<Workspace>>> call(
      GetTopRatedWorkspacesParams params,
      ) async {
    return await repository.getTopRatedWorkspaces(
      userId: params.userId,
      topN: params.topN,
    );
  }
}

class GetTopRatedWorkspacesParams {
  final String userId;
  final int topN;

  GetTopRatedWorkspacesParams({
    required this.userId,
    this.topN = 5,
  });
}

