import '../entities/chat_message_entity.dart';
import '../entities/chatbot_room_entity.dart';

abstract class ChatbotRepository {
  Future<ChatMessageEntity> sendMessage(String message);
  Future<List<RoomEntity>> getRoomsWithImages(List<RoomEntity> rooms);
}

