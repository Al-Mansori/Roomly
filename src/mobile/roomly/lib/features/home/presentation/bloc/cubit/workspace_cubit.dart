import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../GlobalWidgets/app_session.dart';
import '../../../../auth/domain/entities/user_entity.dart';
import '../../../data/data_sources/constants.dart';
import '../../../domain/entities/workspace.dart';
import '../../../domain/usecases/workspace_details_usecase.dart';

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
  final Map<String, List<String>> workspaceImages;

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
    Map<String, List<String>>? workspaceImages,
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
  final List<String> imageUrls;

  const WorkspaceImageLoaded({
    required this.workspaceId,
    required this.imageUrls,
  });

  @override
  List<Object?> get props => [workspaceId, imageUrls];
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


class WorkspaceCubit extends Cubit<WorkspaceState> {
  final GetNearbyWorkspaces getNearbyWorkspaces;
  final GetTopRatedWorkspaces getTopRatedWorkspaces;
  final GetWorkspaceDetails getWorkspaceDetails;
  final GetWorkspaceImages getWorkspaceImages;

  final Map<String, List<String>> _workspaceImages = {};
  List<Workspace> _nearbyWorkspaces = [];
  List<Workspace> _topRatedWorkspaces = [];

  WorkspaceCubit({
    required this.getNearbyWorkspaces,
    required this.getTopRatedWorkspaces,
    required this.getWorkspaceDetails,
    required this.getWorkspaceImages,
  }) : super(WorkspaceInitial());

  // Public API
  Future<void> loadInitialData() async {
    print("🚀 WorkspaceCubit.loadInitialData() CALLED ✅");

    emit(WorkspaceLoading());
    try {
      print("🧭 Calling _loadNearbyWorkspaces");
      await _loadNearbyWorkspaces();
      print("✅ _loadNearbyWorkspaces done");

      print("🧭 Calling _loadTopRatedWorkspaces");
      await _loadTopRatedWorkspaces();
      print("✅ _loadTopRatedWorkspaces done");

      if (_topRatedWorkspaces.isNotEmpty) {
        final firstWorkspaceId = _topRatedWorkspaces.first.id;
        print("🏁 Getting details for workspace: $firstWorkspaceId");
        final result = await getWorkspaceDetails(firstWorkspaceId);

        result.fold(
              (failure) => debugPrint("❌ Failed to load workspace details: ${failure.message}"),
              (workspace) async {
            debugPrint("✅ Loaded workspace details for ID: $firstWorkspaceId");
          },
        );
      }

      _emitLoadedState();
    } catch (e) {
      print("💥 ERROR during loadInitialData: $e");
      emit(WorkspaceError('Failed to load initial data: ${e.toString()}'));
    }
  }

  Future<void> refreshAll() async {
    _clearCache();
    await loadInitialData();
  }
  Future<void> fetchNearbyWorkspaces(double lat, double long) async {
    final UserEntity? user = AppSession().currentUser;

    final userId = user?.id;

    emit(WorkspaceLoading());
    final result = await getNearbyWorkspaces(
      userId: userId!,
      latitude: lat,
      longitude: long,
    );

    result.fold(
          (failure) => emit(WorkspaceError(failure.message)),
          (workspaces) async {
        _nearbyWorkspaces = workspaces;
        try {
          await _cacheWorkspaceImages(workspaces);
        } catch (e) {
          debugPrint("⚠️ Failed to load some workspace images: $e");
        }
        _emitLoadedState(); // Use this instead of emitting empty WorkspaceLoaded
      },
    );
  }

  Future<void> loadWorkspaceDetails(String workspaceId) async {
    emit(WorkspaceDetailsLoading());

    final result = await getWorkspaceDetails(workspaceId);

    await result.fold(
          (failure) {
        emit(WorkspaceDetailsError(failure.message));
      },
          (workspace) async {

        emit(WorkspaceDetailsLoaded(workspace));
      },
    );
  }


  Future<void> loadWorkspaceImages(String workspaceId) async {
    if (_workspaceImages.containsKey(workspaceId)) return;

    emit(WorkspaceImageLoading(workspaceId));

    final result = await getWorkspaceImages(workspaceId);

    result.fold(
          (failure) {
        _workspaceImages[workspaceId] = [];
        emit(WorkspaceImageError(
          workspaceId: workspaceId,
          message: failure.message,
        ));
      },
          (images) {
        _workspaceImages[workspaceId] = images;
        emit(WorkspaceImageLoaded(
          workspaceId: workspaceId,
          imageUrls: images,
        ));
      },
    );
  }

  // Helper methods
  Future<void> _loadNearbyWorkspaces() async {
    final UserEntity? user = AppSession().currentUser;
    final userId = user?.id;
    final coordinates = await HomeConstants.getDefaultCoordinates();

    final result = await getNearbyWorkspaces(
      userId: userId!,
      latitude: coordinates.latitude,
      longitude: coordinates.longitude,
    );

    await result.fold(
          (failure) async {
        debugPrint("❌ Nearby Workspaces API failed: ${failure.message}");
        throw failure;
      },
          (workspaces) async {
        _nearbyWorkspaces = workspaces;

        debugPrint(" Nearby Workspaces succedded");

        try {
          await _cacheWorkspaceImages(workspaces); // ← حاولي هنا فقط
        } catch (e) {
          debugPrint("⚠️ Failed to load some workspace images: $e");
          // مترميش exception هنا علشان ميبقاش Failure في الـ nearby كله
        }
      },
    );
  }

  Future<void> _loadTopRatedWorkspaces() async {
    final UserEntity? user = AppSession().currentUser;
    final userId = user?.id;

    final result = await getTopRatedWorkspaces(userId: userId!);

    await result.fold(
          (failure) async {
        debugPrint("❌ _loadTopRatedWorkspaces failed: ${failure.message}");
        throw failure;
      },
          (workspaces) async {
        List<Workspace> detailedWorkspaces = [];

        for (final workspace in workspaces) {
          final detailsResult = await getWorkspaceDetails(workspace.id);
          await detailsResult.fold(
                (failure) {
              debugPrint("❌ Failed to get details for ${workspace.id}: ${failure.message}");
            },
                (detailed) {
              detailedWorkspaces.add(detailed);
            },
          );
        }

        _topRatedWorkspaces = detailedWorkspaces;

        await _cacheWorkspaceImages(detailedWorkspaces);

        debugPrint("✅ Loaded ${detailedWorkspaces.length} detailed top rated workspaces");
      },
    );
  }

  Future<void> _cacheWorkspaceImages(List<Workspace> workspaces) async {
    await Future.wait(
      workspaces.map((w) => _loadWorkspaceImagesIfNeeded(w.id)),
    );
  }

  Future<void> _loadWorkspaceImagesIfNeeded(String workspaceId) async {
    if (_workspaceImages.containsKey(workspaceId)) return;

    final result = await getWorkspaceImages(workspaceId);

    result.fold(
          (failure) => debugPrint(failure.message),
          (images) => _workspaceImages[workspaceId] = images,
    );
  }




  void _emitLoadedState() {
    emit(WorkspaceLoaded(
      nearbyWorkspaces: _nearbyWorkspaces,
      topRatedWorkspaces: _topRatedWorkspaces,
      workspaceImages: _workspaceImages,
    ));
    debugPrint('Emitted WorkspaceLoaded with:');
    debugPrint(' - ${_nearbyWorkspaces.length} nearby workspaces');
    debugPrint(' - ${_topRatedWorkspaces.length} top rated workspaces');
    debugPrint(' - ${_workspaceImages.length} workspace images');
  }
  void _clearCache() {
    _nearbyWorkspaces = [];
    _topRatedWorkspaces = [];
    _workspaceImages.clear();
  }

  void clearAllData() {
    _clearCache();
    emit(WorkspaceInitial());
  }

  // Getters
  List<String> getWorkspaceImageUrls(String workspaceId) {
    return _workspaceImages[workspaceId] ?? [];
  }
}
