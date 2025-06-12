import 'package:dartz/dartz.dart';
import '../entities/loyalty_points_entity.dart';
import '../repository/loyalty_points_repository.dart';
import '../../../../core/error/failures.dart';

// Abstract UseCase class
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// Use Cases
class GetLoyaltyPoints implements UseCase<LoyaltyPointsEntity, String> {
  final LoyaltyPointsRepository repository;

  GetLoyaltyPoints(this.repository);

  @override
  Future<Either<Failure, LoyaltyPointsEntity>> call(String userId) async {
    return await repository.getLoyaltyPoints(userId);
  }
}

class AddLoyaltyPoints implements UseCase<bool, AddLoyaltyPointsParams> {
  final LoyaltyPointsRepository repository;

  AddLoyaltyPoints(this.repository);

  @override
  Future<Either<Failure, bool>> call(AddLoyaltyPointsParams params) async {
    return await repository.addPoints(params.userId, params.points);
  }
}

class RedeemLoyaltyPoints implements UseCase<bool, RedeemLoyaltyPointsParams> {
  final LoyaltyPointsRepository repository;

  RedeemLoyaltyPoints(this.repository);

  @override
  Future<Either<Failure, bool>> call(RedeemLoyaltyPointsParams params) async {
    return await repository.redeemPoints(params.userId, params.points);
  }
}

// Parameters
class AddLoyaltyPointsParams {
  final String userId;
  final int points;

  AddLoyaltyPointsParams({required this.userId, required this.points});
}

class RedeemLoyaltyPointsParams {
  final String userId;
  final int points;

  RedeemLoyaltyPointsParams({required this.userId, required this.points});
}

