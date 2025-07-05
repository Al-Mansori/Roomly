class BookingRequest {
  final String? userId;
  final String roomId;
  final String workspaceId;
  final String startTime;
  final String endTime;
  final String paymentMethod;
  final int amenitiesCount;
  final int? loyalityPoint;

  BookingRequest({
    required this.userId,
    required this.roomId,
    required this.workspaceId,
    required this.startTime,
    required this.endTime,
    required this.paymentMethod,
    this.amenitiesCount = 2,
    this.loyalityPoint
  });
}
