import 'package:roomly/core/error/failures.dart';

import '../entities/loyalty_points_entity.dart';
import 'package:dartz/dartz.dart';

// Repository Interface (Domain Layer)
abstract class LoyaltyPointsRepository {
  Future<Either<Failure, LoyaltyPointsEntity>> getLoyaltyPoints(String userId);
  Future<Either<Failure, LoyaltyPointsEntity>> updateLoyaltyPoints(LoyaltyPointsEntity loyaltyPoints);
  Future<Either<Failure, bool>> addPoints(String userId, int points);
  Future<Either<Failure, bool>> redeemPoints(String userId, int points);
}

