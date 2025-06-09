import 'package:dartz/dartz.dart';
import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
import 'package:roomly/features/workspace/domain/entities/workspace_entity.dart';

import '../../../../core/error/failures.dart';

abstract class WorkspaceRepository {
  Future<Either<Failure, WorkspaceEntity>> getWorkspaceDetails(String workspaceId);
  Future<Either<Failure, RoomEntity>> getRoomDetails(String roomId);
}


