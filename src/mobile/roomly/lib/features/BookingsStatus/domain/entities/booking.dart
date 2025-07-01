class Booking {
  final String id;
  final DateTime reservationDate;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final int amenitiesCount;
  final double totalCost;
  final dynamic payment;

  Booking({
    required this.id,
    required this.reservationDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.amenitiesCount,
    required this.totalCost,
    this.payment,
  });
}
