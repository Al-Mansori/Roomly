import 'package:equatable/equatable.dart';

import '../../../domain/entities/workspace.dart';

abstract class WorkspaceState extends Equatable {
  const WorkspaceState();

  @override
  List<Object?> get props => [];
}

class WorkspaceInitial extends WorkspaceState {}

class WorkspaceLoading extends WorkspaceState {}

class WorkspaceLoaded extends WorkspaceState {
  final List<Workspace> nearbyWorkspaces;
  final List<Workspace> topRatedWorkspaces;
  final Map<String, String> workspaceImages;

  const WorkspaceLoaded({
    this.nearbyWorkspaces = const [],
    this.topRatedWorkspaces = const [],
    this.workspaceImages = const {},
  });

  @override
  List<Object?> get props => [nearbyWorkspaces, topRatedWorkspaces, workspaceImages];

  WorkspaceLoaded copyWith({
    List<Workspace>? nearbyWorkspaces,
    List<Workspace>? topRatedWorkspaces,
    Map<String, String>? workspaceImages,
  }) {
    return WorkspaceLoaded(
      nearbyWorkspaces: nearbyWorkspaces ?? this.nearbyWorkspaces,
      topRatedWorkspaces: topRatedWorkspaces ?? this.topRatedWorkspaces,
      workspaceImages: workspaceImages ?? this.workspaceImages,
    );
  }
}

class WorkspaceError extends WorkspaceState {
  final String message;

  const WorkspaceError(this.message);

  @override
  List<Object?> get props => [message];
}

class WorkspaceDetailsLoading extends WorkspaceState {}

class WorkspaceDetailsLoaded extends WorkspaceState {
  final Workspace workspace;

  const WorkspaceDetailsLoaded(this.workspace);

  @override
  List<Object?> get props => [workspace];
}

class WorkspaceDetailsError extends WorkspaceState {
  final String message;

  const WorkspaceDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

class WorkspaceImageLoading extends WorkspaceState {
  final String workspaceId;

  const WorkspaceImageLoading(this.workspaceId);

  @override
  List<Object?> get props => [workspaceId];
}

class WorkspaceImageLoaded extends WorkspaceState {
  final String workspaceId;
  final String imageUrl;

  const WorkspaceImageLoaded({
    required this.workspaceId,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [workspaceId, imageUrl];
}

class WorkspaceImageError extends WorkspaceState {
  final String workspaceId;
  final String message;

  const WorkspaceImageError({
    required this.workspaceId,
    required this.message,
  });

  @override
  List<Object?> get props => [workspaceId, message];
}

class RoomsLoading extends WorkspaceState {}
class RoomsLoaded extends WorkspaceState {
  final List<Room> rooms;

  const RoomsLoaded(this.rooms);

  @override
  List<Object?> get props => [rooms];
}
class RoomsError extends WorkspaceState {
  final String message;

  const RoomsError(this.message);

  @override
  List<Object?> get props => [message];
}


// Add these states to workspace_state.dart
class RoomsByTypeLoading extends WorkspaceState {
  final String type;

  const RoomsByTypeLoading(this.type);

  @override
  List<Object?> get props => [type];
}

class RoomsByTypeLoaded extends WorkspaceState {
  final String type;
  final List<Room> rooms;

  const RoomsByTypeLoaded({
    required this.type,
    required this.rooms,
  });

  @override
  List<Object?> get props => [type, rooms];
}

class RoomsByTypeError extends WorkspaceState {
  final String type;
  final String message;

  const RoomsByTypeError({
    required this.type,
    required this.message,
  });

  @override
  List<Object?> get props => [type, message];
}