import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomly/features/GlobalWidgets/app_session.dart';
import 'package:roomly/features/auth/domain/entities/user_entity.dart';
import '../../domain/usecases/loyalty_points_usecases.dart';
import 'loyalty_points_state.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/loyalty_points_entity.dart';

class LoyaltyPointsCubit extends Cubit<LoyaltyPointsState> {
  final GetLoyaltyPoints getLoyaltyPointsUseCase;
  final AddLoyaltyPoints addLoyaltyPointsUseCase;
  final RedeemLoyaltyPoints redeemLoyaltyPointsUseCase;

  LoyaltyPointsCubit({
    required this.getLoyaltyPointsUseCase,
    required this.addLoyaltyPointsUseCase,
    required this.redeemLoyaltyPointsUseCase,
  }) : super(LoyaltyPointsInitial());

  Future<void> loadLoyaltyPoints() async {
    try {
      emit(LoyaltyPointsLoading());

      // Get userId from secure storage
      // final userId = await SecureStorage.getId();
      final UserEntity? user = AppSession().currentUser;
      final userId = user?.id;

      if (userId == null) {
        emit(const LoyaltyPointsError(message: 'User not found. Please login again.'));
        return;
      }

      final result = await getLoyaltyPointsUseCase(userId);
      
      result.fold(
        (failure) {
          if (failure is NoDataFailure) {
            // If no data, emit LoyaltyPointsLoaded with 0 points
            emit(LoyaltyPointsLoaded(
              loyaltyPoints: LoyaltyPointsEntity(
                totalPoints: 0,
                lastAddedPoint: 0,
                lastUpdatedDate: DateTime.now(),
                userId: userId,
              ),
            ));
          } else {
            emit(LoyaltyPointsError(message: failure.message));
          }
        },
        (loyaltyPoints) => emit(LoyaltyPointsLoaded(loyaltyPoints: loyaltyPoints)),
      );
    } catch (e) {
      emit(LoyaltyPointsError(message: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> addPoints(int points) async {
    try {
      final currentState = state;
      if (currentState is! LoyaltyPointsLoaded) {
        emit(const LoyaltyPointsError(message: 'Please load loyalty points first'));
        return;
      }

      emit(LoyaltyPointsActionLoading(
        currentLoyaltyPoints: currentState.loyaltyPoints,
        action: 'adding',
      ));

      final UserEntity? user = AppSession().currentUser;

      final userId = user?.id;
      if (userId == null) {
        emit(const LoyaltyPointsError(message: 'User not found. Please login again.'));
        return;
      }

      final params = AddLoyaltyPointsParams(userId: userId, points: points);
      final result = await addLoyaltyPointsUseCase(params);

      result.fold(
        (failure) => emit(LoyaltyPointsError(message: failure.message)),
        (success) {
          if (success) {
            // Show success message and reload loyalty points
            emit(LoyaltyPointsActionSuccess(
              loyaltyPoints: currentState.loyaltyPoints,
              message: 'Points added successfully!',
            ));
            // Reload loyalty points to get updated data
            loadLoyaltyPoints();
          } else {
            emit(const LoyaltyPointsError(message: 'Failed to add points'));
          }
        },
      );
    } catch (e) {
      emit(LoyaltyPointsError(message: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> redeemPoints(int points) async {
    try {
      final currentState = state;
      if (currentState is! LoyaltyPointsLoaded) {
        emit(const LoyaltyPointsError(message: 'Please load loyalty points first'));
        return;
      }

      // Check if user has enough points
      if (currentState.loyaltyPoints.totalPoints < points) {
        emit(const LoyaltyPointsError(message: 'Insufficient points for redemption'));
        return;
      }

      emit(LoyaltyPointsActionLoading(
        currentLoyaltyPoints: currentState.loyaltyPoints,
        action: 'redeeming',
      ));

      final UserEntity? user = AppSession().currentUser;

      final userId = user?.id;
      if (userId == null) {
        emit(const LoyaltyPointsError(message: 'User not found. Please login again.'));
        return;
      }

      final params = RedeemLoyaltyPointsParams(userId: userId, points: points);
      final result = await redeemLoyaltyPointsUseCase(params);

      result.fold(
        (failure) => emit(LoyaltyPointsError(message: failure.message)),
        (success) {
          if (success) {
            // Show success message and reload loyalty points
            emit(LoyaltyPointsActionSuccess(
              loyaltyPoints: currentState.loyaltyPoints,
              message: 'Points redeemed successfully!',
            ));
            // Reload loyalty points to get updated data
            loadLoyaltyPoints();
          } else {
            emit(const LoyaltyPointsError(message: 'Failed to redeem points'));
          }
        },
      );
    } catch (e) {
      emit(LoyaltyPointsError(message: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> refreshLoyaltyPoints() async {
    await loadLoyaltyPoints();
  }

  void clearError() {
    if (state is LoyaltyPointsError) {
      emit(LoyaltyPointsInitial());
    }
  }

  // Helper method to get current points count
  int getCurrentPoints() {
    final currentState = state;
    if (currentState is LoyaltyPointsLoaded) {
      return currentState.loyaltyPoints.totalPoints;
    } else if (currentState is LoyaltyPointsActionLoading) {
      return currentState.currentLoyaltyPoints.totalPoints;
    } else if (currentState is LoyaltyPointsActionSuccess) {
      return currentState.loyaltyPoints.totalPoints;
    }
    return 0;
  }

  // Helper method to check if user has enough points for redemption
  bool canRedeemPoints(int points) {
    return getCurrentPoints() >= points;
  }

  // Helper method to get last added points
  int getLastAddedPoints() {
    final currentState = state;
    if (currentState is LoyaltyPointsLoaded) {
      return currentState.loyaltyPoints.lastAddedPoint;
    } else if (currentState is LoyaltyPointsActionLoading) {
      return currentState.currentLoyaltyPoints.lastAddedPoint;
    } else if (currentState is LoyaltyPointsActionSuccess) {
      return currentState.loyaltyPoints.lastAddedPoint;
    }
    return 0;
  }

  // Helper method to get last updated date
  DateTime? getLastUpdatedDate() {
    final currentState = state;
    if (currentState is LoyaltyPointsLoaded) {
      return currentState.loyaltyPoints.lastUpdatedDate;
    } else if (currentState is LoyaltyPointsActionLoading) {
      return currentState.currentLoyaltyPoints.lastUpdatedDate;
    } else if (currentState is LoyaltyPointsActionSuccess) {
      return currentState.loyaltyPoints.lastUpdatedDate;
    }
    return null;
  }
}


