import '../models/chatbot_request.dart';
import '../models/chatbot_response.dart';
import '../models/chatbot_room_image.dart';

abstract class ChatbotRemoteDataSource {
  Future<ChatbotResponse> sendMessage(ChatbotRequest request);
  Future<List<RoomImage>> getRoomImages(String roomId);
}

