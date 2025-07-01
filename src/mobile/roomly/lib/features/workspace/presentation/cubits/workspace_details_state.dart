part of 'workspace_details_cubit.dart';

abstract class WorkspaceDetailsState extends Equatable {
  const WorkspaceDetailsState();

  @override
  List<Object> get props => [];
}

class WorkspaceDetailsInitial extends WorkspaceDetailsState {}

class WorkspaceDetailsLoading extends WorkspaceDetailsState {}

class WorkspaceDetailsLoaded extends WorkspaceDetailsState {
  final WorkspaceEntity workspace;
  final int? reviewCount;
  final List<WorkspaceScheduleModel>? schedules;

  const WorkspaceDetailsLoaded({
    required this.workspace,
    this.reviewCount,
    this.schedules,
  });

  @override
  List<Object> get props => [workspace, reviewCount ?? 0, schedules ?? []];
}

class WorkspaceDetailsError extends WorkspaceDetailsState {
  final String message;

  const WorkspaceDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}

class RoomDetailsWorkspaceLoading extends WorkspaceDetailsState {}

class RoomDetailsWorkspaceLoaded extends WorkspaceDetailsState {
  final RoomEntity room;

  const RoomDetailsWorkspaceLoaded({required this.room});

  @override
  List<Object> get props => [room];
}

class RoomDetailsWorkspaceError extends WorkspaceDetailsState {
  final String message;

  const RoomDetailsWorkspaceError({required this.message});

  @override
  List<Object> get props => [message];
}

class WorkspaceReviewsLoading extends WorkspaceDetailsState {}

class WorkspaceReviewsLoaded extends WorkspaceDetailsState {
  final List<dynamic> reviews;

  const WorkspaceReviewsLoaded({required this.reviews});

  @override
  List<Object> get props => [reviews];
}

class WorkspaceReviewsError extends WorkspaceDetailsState {
  final String message;

  const WorkspaceReviewsError({required this.message});

  @override
  List<Object> get props => [message];
}




class WorkspaceSchedulesLoading extends WorkspaceDetailsState {}

class WorkspaceSchedulesLoaded extends WorkspaceDetailsState {
  final List<WorkspaceScheduleModel> schedules;

  const WorkspaceSchedulesLoaded({required this.schedules});

  @override
  List<Object> get props => [schedules];
}

class WorkspaceSchedulesError extends WorkspaceDetailsState {
  final String message;

  const WorkspaceSchedulesError({required this.message});

  @override
  List<Object> get props => [message];
}

