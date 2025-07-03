// import 'dart:math';
// import '../../domain/entities/chat_message_entity.dart';
// import '../../domain/entities/chatbot_room_entity.dart';
// import '../data_sources/chatbot_remote_data_source.dart';
// import '../models/chatbot_request.dart';
// import 'chatbot_repository.dart';

// class ChatbotRepositoryImpl implements ChatbotRepository {
//   final ChatbotRemoteDataSource remoteDataSource;

//   ChatbotRepositoryImpl({required this.remoteDataSource});

//   @override
//   Future<ChatMessageEntity> sendMessage(String message) async {
//     try {
//       final request = ChatbotRequest(message: message);
//       final response = await remoteDataSource.sendMessage(request);
      
//       // Convert rooms to entities
//       final roomEntities = response.rooms.map((room) => RoomEntity(
//         availableCount: room.availableCount,
//         capacity: room.capacity,
//         description: room.description,
//         pricePerHour: room.pricePerHour,
//         roomId: room.roomId,
//         roomName: room.roomName,
//         roomStatus: room.roomStatus,
//         roomType: room.roomType,
//         workspaceId: room.workspaceId,
//         imageUrl: room.imageUrl,
//       )).toList();

//       return ChatMessageEntity(
//         id: _generateId(),
//         message: response.message,
//         isUser: false,
//         timestamp: DateTime.now(),
//         rooms: roomEntities,
//       );
//     } catch (e) {
//       throw Exception('Failed to send message: $e');
//     }
//   }

//   @override
//   Future<List<RoomEntity>> getRoomsWithImages(List<RoomEntity> rooms) async {
//     try {
//       final List<RoomEntity> roomsWithImages = [];
      
//       for (final room in rooms) {
//         try {
//           final images = await remoteDataSource.getRoomImages(room.roomId);
//           final imageUrl = images.isNotEmpty ? images.first.imageUrl : null;
          
//           roomsWithImages.add(room.copyWith(imageUrl: imageUrl));
//         } catch (e) {
//           // If image fetch fails, add room without image
//           roomsWithImages.add(room);
//         }
//       }
      
//       return roomsWithImages;
//     } catch (e) {
//       throw Exception('Failed to get rooms with images: $e');
//     }
//   }

//   String _generateId() {
//     return DateTime.now().millisecondsSinceEpoch.toString() + 
//            Random().nextInt(1000).toString();
//   }
// }



// v2 ----------------------------------------------------------------------------


import 'dart:math';
import 'package:roomly/features/chatbot/domain/entities/chatbot_room_entity.dart';

import '../../domain/entities/chat_message_entity.dart';
import '../data_sources/chatbot_remote_data_source.dart';
import '../models/chatbot_request.dart';
import '../../domain/repositories/chatbot_repository.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotRemoteDataSource remoteDataSource;

  ChatbotRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ChatMessageEntity> sendMessage(String message) async {
    try {
      final request = ChatbotRequest(message: message);
      final response = await remoteDataSource.sendMessage(request);
      
      // Convert rooms to entities
      final roomEntities = response.rooms.map((room) => RoomEntity(
        availableCount: room.availableCount,
        capacity: room.capacity,
        description: room.description,
        pricePerHour: room.pricePerHour,
        roomId: room.roomId,
        roomName: room.roomName,
        roomStatus: room.roomStatus,
        roomType: room.roomType,
        workspaceId: room.workspaceId,
        imageUrl: room.imageUrl,
      )).toList();

      return ChatMessageEntity(
        id: _generateId(),
        message: response.message,
        isUser: false,
        timestamp: DateTime.now(),
        rooms: roomEntities,
      );
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<List<RoomEntity>> getRoomsWithImages(List<RoomEntity> rooms) async {
    try {
      final List<RoomEntity> roomsWithImages = [];
      
      for (final room in rooms) {
        try {
          final images = await remoteDataSource.getRoomImages(room.roomId);
          final imageUrl = images.isNotEmpty ? images.first.imageUrl : null;
          
          roomsWithImages.add(room.copyWith(imageUrl: imageUrl));
        } catch (e) {
          // If image fetch fails, add room without image
          roomsWithImages.add(room);
        }
      }
      
      return roomsWithImages;
    } catch (e) {
      throw Exception('Failed to get rooms with images: $e');
    }
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           Random().nextInt(1000).toString();
  }
}

