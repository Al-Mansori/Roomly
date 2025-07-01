
import 'package:roomly/features/room_management/domain/entities/room_entity.dart';

import 'package:equatable/equatable.dart';
import '../../../../domain/entities/room_entity.dart';

abstract class ReviewBookingState extends Equatable {
  const ReviewBookingState();

  @override
  List<Object?> get props => [];
}

class ReviewBookingInitial extends ReviewBookingState {}

class ReviewBookingLoading extends ReviewBookingState {}

class ReviewBookingLoaded extends ReviewBookingState {
  final RoomEntity room;
  final DateTime selectedDate;
  final String checkInTime;
  final String checkOutTime;
  final int availablePoints;
  final int pointsToRedeem;
  final double discountedPrice;
  final bool showLoyaltyInput;

  const ReviewBookingLoaded({
    required this.room,
    required this.selectedDate,
    required this.checkInTime,
    required this.checkOutTime,
    required this.availablePoints,
    required this.pointsToRedeem,
    required this.discountedPrice,
    required this.showLoyaltyInput,
  });

  @override
  List<Object?> get props => [
    room,
    selectedDate,
    checkInTime,
    checkOutTime,
    availablePoints,
    pointsToRedeem,
    discountedPrice,
    showLoyaltyInput,
  ];
}

class ReviewBookingError extends ReviewBookingState {
  final String message;

  const ReviewBookingError(this.message);

  @override
  List<Object?> get props => [message];
}

class ReviewBookingSuccess extends ReviewBookingState {}

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

// في جزء state/booking_state.dart
class BookingSuccess extends BookingState {
  final String reservationId;

  BookingSuccess(this.reservationId);

  @override
  List<Object> get props => [reservationId];
}
class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}
