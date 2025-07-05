class SeatsAvailability {
  final String roomId;
  final DateTime date;
  final int hour;
  final int availableSeats;
  final int capacity;
  final String status;

  SeatsAvailability({
    required this.roomId,
    required this.date,
    required this.hour,
    required this.availableSeats,
    required this.capacity,
    required this.status,
  });
}
