// review_booking_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomly/features/room_management/domain/entities/room_entity.dart';

import '../../../../../loyalty/domain/repository/loyalty_points_repository.dart';
import '../../../../domain/entities/booking_entity.dart';
import '../../../../domain/usecases/reserve_room_usecase.dart';
import '../state/booking_state.dart';



class ReviewBookingCubit extends Cubit<ReviewBookingState> {
  final LoyaltyPointsRepository loyaltyPointsRepository;
  final RoomEntity room;
  final DateTime selectedDate;
  final String checkInTime;
  final String checkOutTime;
  final String userId;

  ReviewBookingCubit({
    required this.loyaltyPointsRepository,
    required this.room,
    required this.selectedDate,
    required this.checkInTime,
    required this.checkOutTime,
    required this.userId,
  }) : super(ReviewBookingInitial());

  int availablePoints = 0;
  int pointsToRedeem = 0;
  double discountedPrice = 0.0;
  bool showLoyaltyInput = false;

  Future<void> loadLoyaltyPoints() async {
    emit(ReviewBookingLoading());

    final result = await loyaltyPointsRepository.getLoyaltyPoints(userId);

    result.fold(
          (failure) => emit(ReviewBookingError(failure.message)),
          (data) {
        availablePoints = data.totalPoints;
        discountedPrice = room.pricePerHour ?? 57.0;
        emit(_buildLoadedState());
      },
    );
  }

  void toggleLoyaltyInput() {
    showLoyaltyInput = !showLoyaltyInput;
    if (!showLoyaltyInput) {
      pointsToRedeem = 0;
      discountedPrice = room.pricePerHour ?? 57.0;
    }
    emit(_buildLoadedState());
  }

  void updatePointsToRedeem(int value) {
    pointsToRedeem = value;
    emit(_buildLoadedState());
  }

  void applyLoyaltyPoints() {
    if (pointsToRedeem > availablePoints) return;

    discountedPrice = (room.pricePerHour ?? 57.0) - pointsToRedeem;
    if (discountedPrice < 0) discountedPrice = 0;
    emit(_buildLoadedState());
  }

  void useCashPayment() {
    showLoyaltyInput = false;
    pointsToRedeem = 0;
    discountedPrice = room.pricePerHour ?? 57.0;
    emit(_buildLoadedState());
  }

  Future<void> confirmBooking() async {
    if (pointsToRedeem > availablePoints) {
      emit(ReviewBookingError('You don\'t have enough points'));
      return;
    }

    // Redeem points if used
    if (pointsToRedeem > 0) {
      final redeemResult = await loyaltyPointsRepository.redeemPoints(userId, pointsToRedeem);

      final failureOrSuccess = redeemResult.fold(
            (failure) {
          emit(ReviewBookingError(failure.message));
          return false;
        },
            (success) => success,
      );

      if (!failureOrSuccess) return;
    }

    // You can add booking logic here...

    emit(ReviewBookingSuccess());
  }

  ReviewBookingLoaded _buildLoadedState() {
    return ReviewBookingLoaded(
      room: room,
      selectedDate: selectedDate,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      availablePoints: availablePoints,
      pointsToRedeem: pointsToRedeem,
      discountedPrice: discountedPrice,
      showLoyaltyInput: showLoyaltyInput,
    );
  }
}

class BookingCubit extends Cubit<BookingState> {
  final ReserveRoomUseCase reserveRoomUseCase;

  BookingCubit(this.reserveRoomUseCase) : super(BookingInitial());

  Future<void> reserve(BookingRequest request) async {
    emit(BookingLoading());
    try {
      final result = await reserveRoomUseCase(request);
      result.fold(
            (failure) => emit(BookingError(failure.message)),
            (reservationId) => emit(BookingSuccess(reservationId)),
      );
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}

