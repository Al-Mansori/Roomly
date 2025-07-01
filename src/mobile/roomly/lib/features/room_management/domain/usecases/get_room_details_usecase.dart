import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
import 'package:roomly/features/room_management/domain/repositories/room_repository.dart';

class GetRoomDetailsUseCase {
  final RoomRepository repository;

  GetRoomDetailsUseCase(this.repository);

  Future<RoomEntity> call(String roomId) async {
    return await repository.getRoomDetails(roomId);
  }
}

