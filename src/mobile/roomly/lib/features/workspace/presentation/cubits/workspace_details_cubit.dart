import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
import 'package:roomly/features/workspace/data/models/workspace_schedule_model.dart';
import 'package:roomly/features/workspace/domain/entities/workspace_entity.dart';
import 'package:roomly/features/workspace/domain/usecases/get_room_details_usecase.dart';
import 'package:roomly/features/workspace/domain/usecases/get_workspace_details_usecase.dart';
import 'package:roomly/features/workspace/domain/usecases/get_workspace_reviews_usecase.dart';
import 'package:roomly/features/workspace/domain/usecases/get_workspace_schedules_usecase.dart';

part 'workspace_details_state.dart';

class WorkspaceDetailsCubit extends Cubit<WorkspaceDetailsState> {
  final GetWorkspaceDetailsUseCase getWorkspaceDetailsUseCase;
  final GetRoomDetailsUseCase getRoomDetailsUseCase;
  final GetWorkspaceReviewsUseCase getWorkspaceReviewsUseCase;
  final GetWorkspaceSchedulesUseCase getWorkspaceSchedulesUseCase;

  WorkspaceDetailsCubit({
    required this.getWorkspaceDetailsUseCase,
    required this.getRoomDetailsUseCase,
    required this.getWorkspaceReviewsUseCase,
    required this.getWorkspaceSchedulesUseCase,
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
        
        await failureOrReviews.fold(
          (failure) async => emit(WorkspaceDetailsLoaded(workspace: workspace, reviewCount: 0)),
          (reviews) async {
            // Extract review count from the reviews response
            final reviewCount = reviews.length;
            // Fetch workspace schedules
            final failureOrSchedules = await getWorkspaceSchedulesUseCase(workspaceId);
            failureOrSchedules.fold(
              (failure) => emit(WorkspaceDetailsLoaded(workspace: workspace, reviewCount: reviewCount)),
              (schedules) => emit(WorkspaceDetailsLoaded(workspace: workspace, reviewCount: reviewCount, schedules: schedules)),
            );
          },
        );
      },
    );
  }

  Future<void> getRoomDetails(String roomId) async {
    emit(RoomDetailsWorkspaceLoading());
    final failureOrRoom = await getRoomDetailsUseCase(roomId);
    failureOrRoom.fold(
      (failure) => emit(RoomDetailsWorkspaceError(message: 'Failed to load room details')),
      (room) => emit(RoomDetailsWorkspaceLoaded(room: room)),
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

  Future<void> getWorkspaceSchedules(String workspaceId) async {
    emit(WorkspaceSchedulesLoading());
    final failureOrSchedules = await getWorkspaceSchedulesUseCase(workspaceId);
    failureOrSchedules.fold(
      (failure) => emit(WorkspaceSchedulesError(message: 'Failed to load workspace schedules')),
      (schedules) => emit(WorkspaceSchedulesLoaded(schedules: schedules)),
    );
  }
}

