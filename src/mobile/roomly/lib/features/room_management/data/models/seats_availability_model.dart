// data/models/room_availability_model.dart
import '../../domain/entities/seats_availability_entity.dart';

class SeatsAvailabilityModel {
  final String roomId;
  final DateTime date;
  final int hour;
  final int availableSeats;
  final int capacity;
  final String roomStatus;

  SeatsAvailabilityModel({
    required this.roomId,
    required this.date,
    required this.hour,
    required this.availableSeats,
    required this.capacity,
    required this.roomStatus,
  });

  factory SeatsAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return SeatsAvailabilityModel(
      roomId: json['roomId'],
      date: DateTime.parse(json['date']),
      hour: json['hour'],
      availableSeats: json['availableSeats'],
      capacity: json['capacity'],
      roomStatus: json['roomStatus'],
    );
  }

  SeatsAvailability toEntity() {
    return SeatsAvailability(
      roomId: roomId,
      date: date,
      hour: hour,
      availableSeats: availableSeats,
      capacity: capacity,
      status: roomStatus,
    );
  }
}