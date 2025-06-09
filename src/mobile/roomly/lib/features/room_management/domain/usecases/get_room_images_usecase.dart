import 'package:roomly/features/workspace/domain/entities/image_entity.dart';
import 'package:roomly/features/room_management/domain/repositories/room_repository.dart';

class GetRoomImagesUseCase {
  final RoomRepository repository;

  GetRoomImagesUseCase(this.repository);

  Future<List<ImageEntity>> call(String roomId) async {
    return await repository.getRoomImages(roomId);
  }
}

