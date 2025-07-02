import 'package:flutter/material.dart';
import '../../domain/entities/chat_message_entity.dart';
import 'room_card.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessageEntity message;

  const ChatMessageWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: message.isUser 
            ? CrossAxisAlignment.end 
            : CrossAxisAlignment.start,
        children: [
          // Message bubble
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: message.isUser 
                  ? Colors.blue 
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message.message,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          
          // Room cards for bot messages
          if (!message.isUser && message.rooms != null && message.rooms!.isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: message.rooms!
                    .map((room) => RoomCard(room: room))
                    .toList(),
              ),
            ),
          
          // Timestamp
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _formatTime(message.timestamp),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

