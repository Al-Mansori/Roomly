import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:roomly/features/workspace/domain/usecases/get_workspace_reviews_usecase.dart';
import 'package:roomly/features/workspace/domain/entities/review_entity.dart';
import 'package:roomly/features/workspace/domain/usecases/get_user_name_usecase.dart';
import 'package:roomly/features/workspace/domain/usecases/submit_review_usecase.dart';

part 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final GetWorkspaceReviewsUseCase getWorkspaceReviewsUseCase;
  final GetUserNameUseCase getUserNameUseCase;
  final SubmitReviewUseCase submitReviewUseCase;

  ReviewsCubit({
    required this.getWorkspaceReviewsUseCase,
    required this.getUserNameUseCase,
    required this.submitReviewUseCase,
  }) : super(ReviewsInitial());

  Future<void> getReviews(String workspaceId) async {
    emit(ReviewsLoading());
    final failureOrReviews = await getWorkspaceReviewsUseCase(workspaceId);
    failureOrReviews.fold(
      (failure) => emit(ReviewsError(message: 'Failed to load reviews')),
      (reviews) async {
        final List<ReviewEntity> reviewsWithUserNames = [];
        for (var review in reviews) {
          final failureOrUserName = await getUserNameUseCase(review.userId);
          failureOrUserName.fold(
            (failure) => reviewsWithUserNames.add(review.copyWith(userName: 'Unknown User')),
            (user) => reviewsWithUserNames.add(review.copyWith(userName: user.name)),
          );
        }
        emit(ReviewsLoaded(reviews: reviewsWithUserNames));
      },
    );
  }

  Future<void> submitReview({
    required String comment,
    required String userId,
    required String workspaceId,
    required double rating,
  }) async {
    emit(ReviewsLoading());
    final failureOrSuccess = await submitReviewUseCase(
      comment: comment,
      userId: userId,
      workspaceId: workspaceId,
      rating: rating,
    );
    failureOrSuccess.fold(
      (failure) => emit(ReviewsError(message: 'Failed to submit review')),
      (_) {
        getReviews(workspaceId); // Refresh reviews after successful submission
      },
    );
  }
}




