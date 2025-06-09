import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
import 'package:roomly/features/workspace/domain/entities/workspace_entity.dart';
import 'package:roomly/features/workspace/domain/usecases/get_room_details_usecase.dart';
import 'package:roomly/features/workspace/domain/usecases/get_workspace_details_usecase.dart';

part 'workspace_details_state.dart';

class WorkspaceDetailsCubit extends Cubit<WorkspaceDetailsState> {
  final GetWorkspaceDetailsUseCase getWorkspaceDetailsUseCase;
  final GetRoomDetailsUseCase getRoomDetailsUseCase;

  WorkspaceDetailsCubit({
    required this.getWorkspaceDetailsUseCase,
    required this.getRoomDetailsUseCase,
  }) : super(WorkspaceDetailsInitial());

  Future<void> getWorkspaceDetails(String workspaceId) async {
    emit(WorkspaceDetailsLoading());
    final failureOrWorkspace = await getWorkspaceDetailsUseCase(workspaceId);
    failureOrWorkspace.fold(
      (failure) => emit(WorkspaceDetailsError(message: 'Failed to load workspace details')),
      (workspace) => emit(WorkspaceDetailsLoaded(workspace: workspace)),
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
}


