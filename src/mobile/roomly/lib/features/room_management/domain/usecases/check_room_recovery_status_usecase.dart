import 'package:roomly/features/room_management/domain/repositories/room_repository.dart';

class CheckRoomRecoveryStatusUseCase {
  final RoomRepository repository;

  CheckRoomRecoveryStatusUseCase(this.repository);

  Future<bool> execute(String roomId) async {
    return await repository.checkRoomRecoveryStatus(roomId);
  }
}


