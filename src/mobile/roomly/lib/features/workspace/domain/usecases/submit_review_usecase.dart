import 'package:dartz/dartz.dart';
import 'package:roomly/core/error/failures.dart';
import 'package:roomly/features/workspace/domain/repositories/workspace_repository.dart';

class SubmitReviewUseCase {
  final WorkspaceRepository repository;

  SubmitReviewUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String comment,
    required String userId,
    required String workspaceId,
    required double rating,
  }) async {
    return await repository.submitReview(
      comment: comment,
      userId: userId,
      workspaceId: workspaceId,
      rating: rating,
    );
  }
}


