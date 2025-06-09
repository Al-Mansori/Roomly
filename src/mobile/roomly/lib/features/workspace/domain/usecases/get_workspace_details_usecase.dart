import 'package:dartz/dartz.dart';
import 'package:roomly/features/workspace/domain/entities/workspace_entity.dart';
import 'package:roomly/features/workspace/domain/repositories/workspace_repository.dart';
import '../../../../core/error/failures.dart';

class GetWorkspaceDetailsUseCase {
  final WorkspaceRepository repository;

  GetWorkspaceDetailsUseCase({required this.repository});

  Future<Either<Failure, WorkspaceEntity>> call(String workspaceId) async {
    return await repository.getWorkspaceDetails(workspaceId);
  }
}


