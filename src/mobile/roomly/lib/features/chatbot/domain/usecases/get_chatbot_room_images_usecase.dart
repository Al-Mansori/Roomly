import '../entities/chatbot_room_entity.dart';
import '../repositories/chatbot_repository.dart';

class GetRoomImagesUseCase {
  final ChatbotRepository repository;

  GetRoomImagesUseCase({required this.repository});

  Future<List<RoomEntity>> call(List<RoomEntity> rooms) async {
    if (rooms.isEmpty) {
      return rooms;
    }

    try {
      return await repository.getRoomsWithImages(rooms);
    } catch (e) {
      throw Exception('Failed to get room images: $e');
    }
  }
}

