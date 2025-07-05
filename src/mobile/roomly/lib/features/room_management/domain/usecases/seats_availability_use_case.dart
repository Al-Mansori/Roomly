import '../entities/seats_availability_entity.dart';
import '../repositories/seats_repository.dart';

class CheckSeatsAvailabilityUseCase {
  final SeatsAvailabilityRepository repository;

  CheckSeatsAvailabilityUseCase(this.repository);

  Future<List<SeatsAvailability>> call({
    required String roomId,
    required DateTime date,
  }) async {
    return await repository.checkAvailability(
      roomId: roomId,
      date: date,
    );
  }
}
