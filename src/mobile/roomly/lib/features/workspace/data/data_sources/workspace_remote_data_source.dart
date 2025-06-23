// import 'package:roomly/features/room_management/data/models/room_model.dart';
// import 'package:roomly/features/workspace/data/models/workspace_model.dart';

// abstract class WorkspaceRemoteDataSource {
//   Future<WorkspaceModel> getWorkspaceDetails(String workspaceId);
//   Future<RoomModel> getRoomDetails(String roomId);
// }



// v2 ----------------------------------------------------------------------------



// import 'package:roomly/features/room_management/data/models/room_model.dart';
// import 'package:roomly/features/workspace/data/models/review_model.dart';
// import 'package:roomly/features/workspace/data/models/workspace_model.dart';
// import 'package:roomly/features/workspace/domain/entities/user_entity_workspace.dart';

// abstract class WorkspaceRemoteDataSource {
//   Future<WorkspaceModel> getWorkspaceDetails(String workspaceId);
//   Future<RoomModel> getRoomDetails(String roomId);
//   Future<List<ReviewModel>> getWorkspaceReviews(String workspaceId);
//   Future<UserEntity2> getUserName(String userId);
//   Future<void> submitReview({required String comment, required String userId, required String workspaceId, required double rating});
// }



// v10 ----------------------------------------------------------------------------


// import 'package:roomly/features/room_management/data/models/room_model.dart';
// import 'package:roomly/features/workspace/data/models/review_model.dart';
// import 'package:roomly/features/workspace/data/models/workspace_model.dart';
// import 'package:roomly/features/workspace/data/models/workspace_schedule_model.dart';
// import 'package:roomly/features/workspace/domain/entities/user_entity_workspace.dart';

// abstract class WorkspaceRemoteDataSource {
//   Future<WorkspaceModel> getWorkspaceDetails(String workspaceId);
//   Future<RoomModel> getRoomDetails(String roomId);
//   Future<List<ReviewModel>> getWorkspaceReviews(String workspaceId);
//   Future<UserEntity2> getUserName(String userId);
//   Future<void> submitReview({required String comment, required String userId, required String workspaceId, required double rating});
//   Future<List<WorkspaceScheduleModel>> getWorkspaceSchedules(String workspaceId);
// }


// v11 ----------------------------------------------------------------------------


import 'package:roomly/features/room_management/data/models/room_model.dart';
import 'package:roomly/features/workspace/data/models/review_model.dart';
import 'package:roomly/features/workspace/data/models/workspace_model.dart';
import 'package:roomly/features/workspace/data/models/workspace_schedule_model.dart';
import 'package:roomly/features/workspace/domain/entities/user_entity_workspace.dart';

abstract class WorkspaceRemoteDataSource {
  Future<WorkspaceModel> getWorkspaceDetails(String workspaceId);
  Future<RoomModel> getRoomDetails(String roomId);
  Future<List<ReviewModel>> getWorkspaceReviews(String workspaceId);
  Future<UserEntity2> getUserName(String userId);
  Future<void> submitReview({required String comment, required String userId, required String workspaceId, required double rating});
  Future<List<WorkspaceScheduleModel>> getWorkspaceSchedules(String workspaceId);
}