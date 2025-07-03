import '../repositories/bookings_repository.dart';

class CancelReservationUseCase {
  final BookingsRepository repository;

  CancelReservationUseCase(this.repository);

  Future<void> call(
      {required String reservationId, required String userId}) async {
    await repository.cancelReservation(
        reservationId: reservationId, userId: userId);
  }
}
