import 'package:roomly/features/chatbot/data/models/chatbot_room.dart' show Room;

class ChatMessage {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final List<Room>? rooms;

  ChatMessage({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.rooms,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      isUser: json['isUser'] ?? false,
      timestamp: DateTime.parse(json['timestamp']),
      rooms: json['rooms'] != null
          ? (json['rooms'] as List).map((room) => Room.fromJson(room)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'rooms': rooms?.map((room) => room.toJson()).toList(),
    };
  }
}

