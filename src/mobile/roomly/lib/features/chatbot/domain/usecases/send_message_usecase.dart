import '../entities/chat_message_entity.dart';
import '../repositories/chatbot_repository.dart';

class SendMessageUseCase {
  final ChatbotRepository repository;

  SendMessageUseCase({required this.repository});

  Future<ChatMessageEntity> call(String message) async {
    if (message.trim().isEmpty) {
      throw Exception('Message cannot be empty');
    }

    try {
      final response = await repository.sendMessage(message);
      
      // Get rooms with images if rooms are available
      if (response.rooms != null && response.rooms!.isNotEmpty) {
        final roomsWithImages = await repository.getRoomsWithImages(response.rooms!);
        return response.copyWith(rooms: roomsWithImages);
      }
      
      return response;
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}

