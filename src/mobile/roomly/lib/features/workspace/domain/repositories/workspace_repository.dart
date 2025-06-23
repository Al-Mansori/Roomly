// import 'package:dartz/dartz.dart';
// import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
// import 'package:roomly/features/workspace/domain/entities/workspace_entity.dart';

// import '../../../../core/error/failures.dart';

// abstract class WorkspaceRepository {
//   Future<Either<Failure, WorkspaceEntity>> getWorkspaceDetails(String workspaceId);
//   Future<Either<Failure, RoomEntity>> getRoomDetails(String roomId);
// }


// v2 ------------------------------------------------------

// import 'package:dartz/dartz.dart';
// import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
// import 'package:roomly/features/workspace/domain/entities/review_entity.dart';
// import 'package:roomly/features/workspace/domain/entities/user_entity_workspace.dart';
// import 'package:roomly/features/workspace/domain/entities/workspace_entity.dart';

// import '../../../../core/error/failures.dart';

// abstract class WorkspaceRepository {
//   Future<Either<Failure, WorkspaceEntity>> getWorkspaceDetails(String workspaceId);
//   Future<Either<Failure, RoomEntity>> getRoomDetails(String roomId);
//   Future<Either<Failure, List<ReviewEntity>>> getWorkspaceReviews(String workspaceId);
//   Future<Either<Failure, UserEntity2>> getUserName(String userId);
//   Future<Either<Failure, void>> submitReview({required String comment, required String userId, required String workspaceId, required double rating});
// }


// v10 ---------------------------------------------------------------------------------



// import 'package:dartz/dartz.dart';
// import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
// import 'package:roomly/features/workspace/domain/entities/review_entity.dart';
// import 'package:roomly/features/workspace/domain/entities/user_entity_workspace.dart';
// import 'package:roomly/features/workspace/domain/entities/workspace_entity.dart';
// import 'package:roomly/features/workspace/data/models/workspace_schedule_model.dart';

// import '../../../../core/error/failures.dart';

// abstract class WorkspaceRepository {
//   Future<Either<Failure, WorkspaceEntity>> getWorkspaceDetails(String workspaceId);
//   Future<Either<Failure, RoomEntity>> getRoomDetails(String roomId);
//   Future<Either<Failure, List<ReviewEntity>>> getWorkspaceReviews(String workspaceId);
//   Future<Either<Failure, UserEntity2>> getUserName(String userId);
//   Future<Either<Failure, void>> submitReview({required String comment, required String userId, required String workspaceId, required double rating});
//   Future<Either<Failure, List<WorkspaceScheduleModel>>> getWorkspaceSchedules(String workspaceId);
// }



// v11 ---------------------------------------------------------------------------------



import 'package:dartz/dartz.dart';
import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
import 'package:roomly/features/workspace/domain/entities/review_entity.dart';
import 'package:roomly/features/workspace/domain/entities/user_entity_workspace.dart';
import 'package:roomly/features/workspace/domain/entities/workspace_entity.dart';
import 'package:roomly/features/workspace/data/models/workspace_schedule_model.dart';

import '../../../../core/error/failures.dart';

abstract class WorkspaceRepository {
  Future<Either<Failure, WorkspaceEntity>> getWorkspaceDetails(String workspaceId);
  Future<Either<Failure, RoomEntity>> getRoomDetails(String roomId);
  Future<Either<Failure, List<ReviewEntity>>> getWorkspaceReviews(String workspaceId);
  Future<Either<Failure, UserEntity2>> getUserName(String userId);
  Future<Either<Failure, void>> submitReview({required String comment, required String userId, required String workspaceId, required double rating});
  Future<Either<Failure, List<WorkspaceScheduleModel>>> getWorkspaceSchedules(String workspaceId);
}

