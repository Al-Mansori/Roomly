import '../entities/seats_availability_entity.dart';

abstract class SeatsAvailabilityRepository {
  Future<List<SeatsAvailability>> checkAvailability({
    required String roomId,
    required DateTime date,
  });
}
