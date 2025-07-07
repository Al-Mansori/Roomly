class BookingDetails {
  final dynamic room;
  final DateTime selectedDate;
  final String checkInTime;
  final String checkOutTime;
  final int numberOfSeats;
  final bool isDailyBooking;
  final double discountedPrice;
  final double totalPrice;
  final String workspaceId;
  final int availableSeats;

  BookingDetails({
    required this.room,
    required this.selectedDate,
    required this.checkInTime,
    required this.checkOutTime,
    required this.numberOfSeats,
    required this.isDailyBooking,
    required this.discountedPrice,
    required this.totalPrice,
    required this.workspaceId,
    required this.availableSeats,
  });
}

class TimeSlot {
  final String displayTime;
  final DateTime time;
  final bool isAvailable;

  TimeSlot({
    required this.displayTime,
    required this.time,
    required this.isAvailable,
  });
}