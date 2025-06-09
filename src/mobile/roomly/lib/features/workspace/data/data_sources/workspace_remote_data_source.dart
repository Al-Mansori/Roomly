import 'package:roomly/features/room_management/data/models/room_model.dart';
import 'package:roomly/features/workspace/data/models/workspace_model.dart';

abstract class WorkspaceRemoteDataSource {
  Future<WorkspaceModel> getWorkspaceDetails(String workspaceId);
  Future<RoomModel> getRoomDetails(String roomId);
}


