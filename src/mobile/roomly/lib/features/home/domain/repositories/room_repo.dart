// lib/features/rooms/domain/repositories/room_repository.dart
import 'package:roomly/features/home/data/models/room_for_type_model.dart';

import '../../data/models/workspace_model.dart';

abstract class RoomRepository {
  Future<List<RoomModelForType>> getRoomsByType(String type);
}