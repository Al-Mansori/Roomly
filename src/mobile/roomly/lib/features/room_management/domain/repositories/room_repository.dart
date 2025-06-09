import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
import 'package:roomly/features/workspace/domain/entities/image_entity.dart';

abstract class RoomRepository {
  Future<RoomEntity> getRoomDetails(String roomId);
  Future<List<ImageEntity>> getRoomImages(String roomId);
}

