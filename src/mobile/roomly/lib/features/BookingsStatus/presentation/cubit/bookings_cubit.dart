import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/booking_with_room.dart';
import '../../domain/usecases/get_user_bookings.dart';
import '../../domain/usecases/cancel_reservation_usecase.dart';

// Events
abstract class BookingsEvent extends Equatable {
  const BookingsEvent();

  @override
  List<Object> get props => [];
}

class LoadBookings extends BookingsEvent {
  final String userId;

  const LoadBookings(this.userId);

  @override
  List<Object> get props => [userId];
}

// States
abstract class BookingsState extends Equatable {
  const BookingsState();

  @override
  List<Object> get props => [];
}

class BookingsInitial extends BookingsState {}

class BookingsLoading extends BookingsState {}

class BookingsLoaded extends BookingsState {
  final List<BookingWithRoom> bookings;

  const BookingsLoaded(this.bookings);

  @override
  List<Object> get props => [bookings];
}

class BookingsError extends BookingsState {
  final String message;

  const BookingsError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class BookingsCubit extends Cubit<BookingsState> {
  final GetUserBookings getUserBookings;
  final CancelReservationUseCase cancelReservationUseCase;

  BookingsCubit(
      {required this.getUserBookings, required this.cancelReservationUseCase})
      : super(BookingsInitial());

  Future<void> loadBookings(String userId) async {
    emit(BookingsLoading());
    try {
      final bookings = await getUserBookings(userId);
      emit(BookingsLoaded(bookings));
    } catch (e) {
      emit(BookingsError(e.toString()));
    }
  }

  Future<void> cancelReservation(
      {required String reservationId, required String userId}) async {
    try {
      await cancelReservationUseCase(
          reservationId: reservationId, userId: userId);
      await loadBookings(userId); // Refresh bookings after cancel
    } catch (e) {
      emit(BookingsError(e.toString()));
    }
  }
}
