import 'package:dartz/dartz.dart';
import 'package:roomly/core/error/failures.dart';
import 'package:roomly/features/workspace/domain/entities/review_entity.dart';
import 'package:roomly/features/workspace/domain/repositories/workspace_repository.dart';

class GetWorkspaceReviewsUseCase {
  final WorkspaceRepository repository;

  GetWorkspaceReviewsUseCase(this.repository);

  Future<Either<Failure, List<ReviewEntity>>> call(String workspaceId) async {
    return await repository.getWorkspaceReviews(workspaceId);
  }
}


