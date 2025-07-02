import 'chatbot_room_entity.dart';

class ChatMessageEntity {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final List<RoomEntity>? rooms;

  ChatMessageEntity({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.rooms,
  });

  ChatMessageEntity copyWith({
    String? id,
    String? message,
    bool? isUser,
    DateTime? timestamp,
    List<RoomEntity>? rooms,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      message: message ?? this.message,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      rooms: rooms ?? this.rooms,
    );
  }
}

