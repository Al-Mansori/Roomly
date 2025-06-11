import '../../domain/entities/booking.dart';

class BookingModel extends Booking {
  BookingModel({
    required String id,
    required DateTime reservationDate,
    required DateTime startTime,
    required DateTime endTime,
    required String status,
    required int amenitiesCount,
    required double totalCost,
    dynamic payment,
  }) : super(
          id: id,
          reservationDate: reservationDate,
          startTime: startTime,
          endTime: endTime,
          status: status,
          amenitiesCount: amenitiesCount,
          totalCost: totalCost,
          payment: payment,
        );

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      reservationDate: DateTime.parse(json['reservationDate']),
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      status: json['status'],
      amenitiesCount: json['amenitiesCount'],
      totalCost: (json['totalCost'] as num).toDouble(),
      payment: json['payment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reservationDate': reservationDate.toIso8601String(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status,
      'amenitiesCount': amenitiesCount,
      'totalCost': totalCost,
      'payment': payment,
    };
  }
}
