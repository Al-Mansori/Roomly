import 'package:dartz/dartz.dart';
import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
import 'package:roomly/features/workspace/domain/repositories/workspace_repository.dart';
import '../../../../core/error/failures.dart';

class GetRoomDetailsUseCase {
  final WorkspaceRepository repository;

  GetRoomDetailsUseCase({required this.repository});

  Future<Either<Failure, RoomEntity>> call(String roomId) async {
    return await repository.getRoomDetails(roomId);
  }
}


