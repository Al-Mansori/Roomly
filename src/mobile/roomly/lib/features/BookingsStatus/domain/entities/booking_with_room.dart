import 'booking.dart';
import 'room_details.dart';

class BookingWithRoom {
  final Booking reservation;
  final String roomId;
  final String workspaceId;
  final RoomDetails roomDetails;

  BookingWithRoom({
    required this.reservation,
    required this.roomId,
    required this.workspaceId,
    required this.roomDetails,
  });
}
