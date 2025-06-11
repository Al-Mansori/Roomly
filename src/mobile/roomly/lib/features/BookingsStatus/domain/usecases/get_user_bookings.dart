import '../entities/booking_with_room.dart';
import '../repositories/bookings_repository.dart';

class GetUserBookings {
  final BookingsRepository repository;

  GetUserBookings(this.repository);

  Future<List<BookingWithRoom>> call(String userId) async {
    return await repository.getUserBookings(userId);
  }
}
