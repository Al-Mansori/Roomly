// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
// import 'package:roomly/features/workspace/domain/entities/workspace_entity.dart';
// import 'package:roomly/features/workspace/domain/usecases/get_room_details_usecase.dart';
// import 'package:roomly/features/workspace/domain/usecases/get_workspace_details_usecase.dart';

// part 'workspace_details_state.dart';

// class WorkspaceDetailsCubit extends Cubit<WorkspaceDetailsState> {
//   final GetWorkspaceDetailsUseCase getWorkspaceDetailsUseCase;
//   final GetRoomDetailsUseCase getRoomDetailsUseCase;

//   WorkspaceDetailsCubit({
//     required this.getWorkspaceDetailsUseCase,
//     required this.getRoomDetailsUseCase,
//   }) : super(WorkspaceDetailsInitial());

//   Future<void> getWorkspaceDetails(String workspaceId) async {
//     emit(WorkspaceDetailsLoading());
//     final failureOrWorkspace = await getWorkspaceDetailsUseCase(workspaceId);
//     failureOrWorkspace.fold(
//       (failure) => emit(WorkspaceDetailsError(message: 'Failed to load workspace details')),
//       (workspace) => emit(WorkspaceDetailsLoaded(workspace: workspace)),
//     );
//   }

//   Future<void> getRoomDetails(String roomId) async {
//     emit(RoomDetailsLoading());
//     final failureOrRoom = await getRoomDetailsUseCase(roomId);
//     failureOrRoom.fold(
//       (failure) => emit(RoomDetailsError(message: 'Failed to load room details')),
//       (room) => emit(RoomDetailsLoaded(room: room)),
//     );
//   }
// }



// v2 ------------------------------------------------------------------------------------


import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
import 'package:roomly/features/workspace/domain/entities/workspace_entity.dart';
import 'package:roomly/features/workspace/domain/usecases/get_room_details_usecase.dart';
import 'package:roomly/features/workspace/domain/usecases/get_workspace_details_usecase.dart';
import 'package:roomly/features/workspace/domain/usecases/get_workspace_reviews_usecase.dart';

part 'workspace_details_state.dart';

class WorkspaceDetailsCubit extends Cubit<WorkspaceDetailsState> {
  final GetWorkspaceDetailsUseCase getWorkspaceDetailsUseCase;
  final GetRoomDetailsUseCase getRoomDetailsUseCase;
  final GetWorkspaceReviewsUseCase getWorkspaceReviewsUseCase;

  WorkspaceDetailsCubit({
    required this.getWorkspaceDetailsUseCase,
    required this.getRoomDetailsUseCase,
    required this.getWorkspaceReviewsUseCase,
  }) : super(WorkspaceDetailsInitial());

  Future<void> getWorkspaceDetails(String workspaceId) async {
    emit(WorkspaceDetailsLoading());
    
    // Fetch workspace details
    final failureOrWorkspace = await getWorkspaceDetailsUseCase(workspaceId);
    
    await failureOrWorkspace.fold(
      (failure) async => emit(WorkspaceDetailsError(message: 'Failed to load workspace details')),
      (workspace) async {
        // Fetch review count
        final failureOrReviews = await getWorkspaceReviewsUseCase(workspaceId);
        
        failureOrReviews.fold(
          (failure) => emit(WorkspaceDetailsLoaded(workspace: workspace, reviewCount: 0)),
          (reviews) {
            // Extract review count from the reviews response
            final reviewCount = reviews.length;
            emit(WorkspaceDetailsLoaded(workspace: workspace, reviewCount: reviewCount));
          },
        );
      },
    );
  }

  Future<void> getRoomDetails(String roomId) async {
    emit(RoomDetailsLoading());
    final failureOrRoom = await getRoomDetailsUseCase(roomId);
    failureOrRoom.fold(
      (failure) => emit(RoomDetailsError(message: 'Failed to load room details')),
      (room) => emit(RoomDetailsLoaded(room: room)),
    );
  }

  Future<void> getWorkspaceReviews(String workspaceId) async {
    emit(WorkspaceReviewsLoading());
    final failureOrReviews = await getWorkspaceReviewsUseCase(workspaceId);
    failureOrReviews.fold(
      (failure) => emit(WorkspaceReviewsError(message: 'Failed to load workspace reviews')),
      (reviews) => emit(WorkspaceReviewsLoaded(reviews: reviews)),
    );
  }
}

