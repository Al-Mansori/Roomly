import 'package:equatable/equatable.dart';
import '../../domain/entities/loyalty_points_entity.dart';

// Loyalty Points States
abstract class LoyaltyPointsState extends Equatable {
  const LoyaltyPointsState();

  @override
  List<Object?> get props => [];
}

class LoyaltyPointsInitial extends LoyaltyPointsState {}

class LoyaltyPointsLoading extends LoyaltyPointsState {}

class LoyaltyPointsLoaded extends LoyaltyPointsState {
  final LoyaltyPointsEntity loyaltyPoints;

  const LoyaltyPointsLoaded({required this.loyaltyPoints});

  @override
  List<Object?> get props => [loyaltyPoints];
}

class LoyaltyPointsError extends LoyaltyPointsState {
  final String message;

  const LoyaltyPointsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class LoyaltyPointsActionLoading extends LoyaltyPointsState {
  final LoyaltyPointsEntity currentLoyaltyPoints;
  final String action; // 'adding' or 'redeeming'

  const LoyaltyPointsActionLoading({
    required this.currentLoyaltyPoints,
    required this.action,
  });

  @override
  List<Object?> get props => [currentLoyaltyPoints, action];
}

class LoyaltyPointsActionSuccess extends LoyaltyPointsState {
  final LoyaltyPointsEntity loyaltyPoints;
  final String message;

  const LoyaltyPointsActionSuccess({
    required this.loyaltyPoints,
    required this.message,
  });

  @override
  List<Object?> get props => [loyaltyPoints, message];
}

