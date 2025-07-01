import 'package:flutter/foundation.dart';

import '../../../data/data_sources/constants.dart';
import '../../../domain/entities/workspace.dart';
import '../../../domain/usecases/workspace_details_usecase.dart';

enum WorkspaceState { initial, loading, loaded, error }

class WorkspaceProvider extends ChangeNotifier {
  final GetNearbyWorkspaces getNearbyWorkspaces;
  final GetTopRatedWorkspaces getTopRatedWorkspaces;
  final GetWorkspaceDetails getWorkspaceDetails;
  final GetWorkspaceImages getWorkspaceImages;

  // State variables
  WorkspaceState _nearbyState = WorkspaceState.initial;
  WorkspaceState _topRatedState = WorkspaceState.initial;
  WorkspaceState _detailsState = WorkspaceState.initial;
  WorkspaceState _imageState = WorkspaceState.initial;

  List<Workspace> _nearbyWorkspaces = [];
  List<Workspace> _topRatedWorkspaces = [];
  Workspace? _selectedWorkspace;
  Map<String, List<String>> _workspaceImages = {};

  String? _nearbyError;
  String? _topRatedError;
  String? _detailsError;
  String? _imageError;

  WorkspaceProvider({
    required this.getNearbyWorkspaces,
    required this.getTopRatedWorkspaces,
    required this.getWorkspaceDetails,
    required this.getWorkspaceImages,
  });

  // Getters
  WorkspaceState get nearbyState => _nearbyState;
  WorkspaceState get topRatedState => _topRatedState;
  WorkspaceState get detailsState => _detailsState;
  WorkspaceState get imageState => _imageState;

  List<Workspace> get nearbyWorkspaces => _nearbyWorkspaces;
  List<Workspace> get topRatedWorkspaces => _topRatedWorkspaces;
  Workspace? get selectedWorkspace => _selectedWorkspace;
  Map<String, List<String>> get workspaceImages => _workspaceImages;

  String? get nearbyError => _nearbyError;
  String? get topRatedError => _topRatedError;
  String? get detailsError => _detailsError;
  String? get imageError => _imageError;

  // Main methods
  Future<void> loadAllWorkspaces() async {
    final coordinates = await HomeConstants.getDefaultCoordinates();
    await Future.wait([
      fetchNearbyWorkspaces(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
      ),
      fetchTopRatedWorkspaces(),
    ]);
  }

  Future<void> fetchNearbyWorkspaces({
    String? userId,
    required double latitude,
    required double longitude,
    int topN = 10,
  }) async {
    try {
      _nearbyState = WorkspaceState.loading;
      _nearbyError = null;
      notifyListeners();

      final resolvedUserId = userId ?? await HomeConstants.getUserId();
      if (resolvedUserId == null) {
        _nearbyState = WorkspaceState.error;
        _nearbyError = 'User ID not available';
        notifyListeners();
        return;
      }

      final result = await getNearbyWorkspaces(
        userId: resolvedUserId,
        latitude: latitude,
        longitude: longitude,
        topN: topN,
      );

      result.fold(
            (failure) {
          _nearbyState = WorkspaceState.error;
          _nearbyError = failure.message;
          _nearbyWorkspaces = [];
        },
            (workspaces) {
          _nearbyState = WorkspaceState.loaded;
          _nearbyWorkspaces = workspaces;
          _loadWorkspaceImages(workspaces);
        },
      );
    } catch (e) {
      _nearbyState = WorkspaceState.error;
      _nearbyError = 'Failed to fetch nearby workspaces';
      _nearbyWorkspaces = [];
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchTopRatedWorkspaces({
    String? userId,
    int topN = 10,
  }) async {
    try {
      _topRatedState = WorkspaceState.loading;
      _topRatedError = null;
      notifyListeners();

      final resolvedUserId = userId ?? await HomeConstants.getUserId();
      if (resolvedUserId == null) {
        _topRatedState = WorkspaceState.error;
        _topRatedError = 'User ID not available';
        notifyListeners();
        return;
      }

      final result = await getTopRatedWorkspaces(
        userId: resolvedUserId,
        topN: topN,
      );

      result.fold(
            (failure) {
          _topRatedState = WorkspaceState.error;
          _topRatedError = failure.message;
          _topRatedWorkspaces = [];
        },
            (workspaces) {
          _topRatedState = WorkspaceState.loaded;
          _topRatedWorkspaces = workspaces;
          _loadWorkspaceImages(workspaces);
        },
      );
    } catch (e) {
      _topRatedState = WorkspaceState.error;
      _topRatedError = 'Failed to fetch top rated workspaces';
      _topRatedWorkspaces = [];
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchWorkspaceDetails(String workspaceId) async {
    try {
      _detailsState = WorkspaceState.loading;
      _detailsError = null;
      notifyListeners();

      final result = await getWorkspaceDetails(workspaceId);

      result.fold(
            (failure) {
          _detailsState = WorkspaceState.error;
          _detailsError = failure.message;
          _selectedWorkspace = null;
        },
            (workspace) {
          _detailsState = WorkspaceState.loaded;
          _selectedWorkspace = workspace;
        },
      );
    } catch (e) {
      _detailsState = WorkspaceState.error;
      _detailsError = 'Failed to fetch workspace details';
      _selectedWorkspace = null;
    } finally {
      notifyListeners();
    }
  }

  // Helper methods
  Future<void> _loadWorkspaceImages(List<Workspace> workspaces) async {
    for (final workspace in workspaces) {
      if (!_workspaceImages.containsKey(workspace.id)) {
        await _fetchWorkspaceImages(workspace.id);
      }
    }
  }

  Future<void> _fetchWorkspaceImages(String workspaceId) async {
    try {
      _imageState = WorkspaceState.loading;
      notifyListeners();

      final result = await getWorkspaceImages(workspaceId);

      result.fold(
            (failure) {
          _workspaceImages[workspaceId] = [];
          _imageError = failure.message;
        },
            (images) {
          _workspaceImages[workspaceId] = images;
          _imageError = null;
        },
      );
    } catch (e) {
      _workspaceImages[workspaceId] = [];
      _imageError = 'Failed to fetch workspace images';
    } finally {
      _imageState = WorkspaceState.loaded;
      notifyListeners();
    }
  }


  void clearAllData() {
    _nearbyWorkspaces = [];
    _topRatedWorkspaces = [];
    _selectedWorkspace = null;
    _workspaceImages = {};

    _nearbyState = WorkspaceState.initial;
    _topRatedState = WorkspaceState.initial;
    _detailsState = WorkspaceState.initial;
    _imageState = WorkspaceState.initial;

    _nearbyError = null;
    _topRatedError = null;
    _detailsError = null;
    _imageError = null;

    notifyListeners();
  }
}