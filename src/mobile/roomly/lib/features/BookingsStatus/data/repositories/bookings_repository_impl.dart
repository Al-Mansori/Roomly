import '../../domain/entities/booking.dart';
import '../../domain/entities/booking_with_room.dart';
import '../../domain/entities/room_details.dart';
import '../../domain/repositories/bookings_repository.dart';
import '../data_sources/bookings_remote_data_source.dart';
import '../data_sources/room_remote_data_source.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  final BookingsRemoteDataSource remoteDataSource;
  final RoomRemoteDataSource roomRemoteDataSource;

  BookingsRepositoryImpl({
    required this.remoteDataSource,
    required this.roomRemoteDataSource,
  });

  @override
  Future<List<BookingWithRoom>> getUserBookings(String userId) async {
    // Fetch the bookings with roomId and workspaceId from the API
    final rawList = await remoteDataSource.getUserBookings(userId);
    // rawList should be a List<Map<String, dynamic>>
    List<BookingWithRoom> result = [];
    for (final item in rawList) {
      final booking = item['reservation'] as Booking;
      final roomId = item['roomId'] as String;
      final workspaceId = item['workspaceId'] as String;
      final roomDetails = await roomRemoteDataSource.getRoomDetails(roomId);
      result.add(BookingWithRoom(
        reservation: booking,
        roomId: roomId,
        workspaceId: workspaceId,
        roomDetails: roomDetails,
      ));
    }
    return result;
  }

  @override
  Future<void> cancelReservation(
      {required String reservationId, required String userId}) async {
    await remoteDataSource.cancelReservation(
        reservationId: reservationId, userId: userId);
  }
}
