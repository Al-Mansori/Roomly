// part of 'workspace_details_cubit.dart';

// abstract class WorkspaceDetailsState extends Equatable {
//   const WorkspaceDetailsState();

//   @override
//   List<Object> get props => [];
// }

// class WorkspaceDetailsInitial extends WorkspaceDetailsState {}

// class WorkspaceDetailsLoading extends WorkspaceDetailsState {}

// class WorkspaceDetailsLoaded extends WorkspaceDetailsState {
//   final WorkspaceEntity workspace;

//   const WorkspaceDetailsLoaded({required this.workspace});

//   @override
//   List<Object> get props => [workspace];
// }

// class WorkspaceDetailsError extends WorkspaceDetailsState {
//   final String message;

//   const WorkspaceDetailsError({required this.message});

//   @override
//   List<Object> get props => [message];
// }

// class RoomDetailsLoading extends WorkspaceDetailsState {}

// class RoomDetailsLoaded extends WorkspaceDetailsState {
//   final RoomEntity room;

//   const RoomDetailsLoaded({required this.room});

//   @override
//   List<Object> get props => [room];
// }

// class RoomDetailsError extends WorkspaceDetailsState {
//   final String message;

//   const RoomDetailsError({required this.message});

//   @override
//   List<Object> get props => [message];
// }


// v2 ----------------------------------------------------------------



// part of 'workspace_details_cubit.dart';

// abstract class WorkspaceDetailsState extends Equatable {
//   const WorkspaceDetailsState();

//   @override
//   List<Object> get props => [];
// }

// class WorkspaceDetailsInitial extends WorkspaceDetailsState {}

// class WorkspaceDetailsLoading extends WorkspaceDetailsState {}

// class WorkspaceDetailsLoaded extends WorkspaceDetailsState {
//   final WorkspaceEntity workspace;
//   final int? reviewCount;

//   const WorkspaceDetailsLoaded({
//     required this.workspace,
//     this.reviewCount,
//   });

//   @override
//   List<Object> get props => [workspace, reviewCount ?? 0];
// }

// class WorkspaceDetailsError extends WorkspaceDetailsState {
//   final String message;

//   const WorkspaceDetailsError({required this.message});

//   @override
//   List<Object> get props => [message];
// }

// class RoomDetailsLoading extends WorkspaceDetailsState {}

// class RoomDetailsLoaded extends WorkspaceDetailsState {
//   final RoomEntity room;

//   const RoomDetailsLoaded({required this.room});

//   @override
//   List<Object> get props => [room];
// }

// class RoomDetailsError extends WorkspaceDetailsState {
//   final String message;

//   const RoomDetailsError({required this.message});

//   @override
//   List<Object> get props => [message];
// }

// class WorkspaceReviewsLoading extends WorkspaceDetailsState {}

// class WorkspaceReviewsLoaded extends WorkspaceDetailsState {
//   final List<dynamic> reviews;

//   const WorkspaceReviewsLoaded({required this.reviews});

//   @override
//   List<Object> get props => [reviews];
// }

// class WorkspaceReviewsError extends WorkspaceDetailsState {
//   final String message;

//   const WorkspaceReviewsError({required this.message});

//   @override
//   List<Object> get props => [message];
// }


// v10 ---------------------------------------------------------------------------------



// part of 'workspace_details_cubit.dart';

// abstract class WorkspaceDetailsState extends Equatable {
//   const WorkspaceDetailsState();

//   @override
//   List<Object> get props => [];
// }

// class WorkspaceDetailsInitial extends WorkspaceDetailsState {}

// class WorkspaceDetailsLoading extends WorkspaceDetailsState {}

// class WorkspaceDetailsLoaded extends WorkspaceDetailsState {
//   final WorkspaceEntity workspace;
//   final int? reviewCount;
//   final List<WorkspaceScheduleModel>? schedules;

//   const WorkspaceDetailsLoaded({
//     required this.workspace,
//     this.reviewCount,
//     this.schedules,
//   });

//   @override
//   List<Object> get props => [workspace, reviewCount ?? 0, schedules ?? []];
// }

// class WorkspaceDetailsError extends WorkspaceDetailsState {
//   final String message;

//   const WorkspaceDetailsError({required this.message});

//   @override
//   List<Object> get props => [message];
// }

// class RoomDetailsLoading extends WorkspaceDetailsState {}

// class RoomDetailsLoaded extends WorkspaceDetailsState {
//   final RoomEntity room;

//   const RoomDetailsLoaded({required this.room});

//   @override
//   List<Object> get props => [room];
// }

// class RoomDetailsError extends WorkspaceDetailsState {
//   final String message;

//   const RoomDetailsError({required this.message});

//   @override
//   List<Object> get props => [message];
// }

// class WorkspaceReviewsLoading extends WorkspaceDetailsState {}

// class WorkspaceReviewsLoaded extends WorkspaceDetailsState {
//   final List<dynamic> reviews;

//   const WorkspaceReviewsLoaded({required this.reviews});

//   @override
//   List<Object> get props => [reviews];
// }

// class WorkspaceReviewsError extends WorkspaceDetailsState {
//   final String message;

//   const WorkspaceReviewsError({required this.message});

//   @override
//   List<Object> get props => [message];
// }




// class WorkspaceSchedulesLoading extends WorkspaceDetailsState {}

// class WorkspaceSchedulesLoaded extends WorkspaceDetailsState {
//   final List<WorkspaceScheduleModel> schedules;

//   const WorkspaceSchedulesLoaded({required this.schedules});

//   @override
//   List<Object> get props => [schedules];
// }

// class WorkspaceSchedulesError extends WorkspaceDetailsState {
//   final String message;

//   const WorkspaceSchedulesError({required this.message});

//   @override
//   List<Object> get props => [message];
// }



// v11 ---------------------------------------------------------------------------------


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

