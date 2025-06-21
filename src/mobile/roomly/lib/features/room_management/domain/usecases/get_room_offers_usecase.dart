import 'package:roomly/features/room_management/domain/entities/offer_entity.dart';
import 'package:roomly/features/room_management/domain/repositories/room_repository.dart';

class GetRoomOffersUseCase {
  final RoomRepository repository;

  GetRoomOffersUseCase(this.repository);

  Future<List<OfferEntity>> call(String roomId) async {
    return await repository.getRoomOffers(roomId);
  }
}

