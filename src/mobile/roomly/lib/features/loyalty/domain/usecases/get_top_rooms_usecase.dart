import 'package:dartz/dartz.dart';
import 'package:roomly/core/error/failures.dart';
import 'package:roomly/features/loyalty/domain/entities/room_loyalty_entity.dart';
import 'package:roomly/features/loyalty/domain/repository/loyalty_points_repository.dart';
import 'package:roomly/features/loyalty/domain/usecases/loyalty_points_usecases.dart';

class GetTopRooms implements UseCase<List<TopRoomEntity>, NoParams> {
  final LoyaltyPointsRepository repository;

  GetTopRooms(this.repository);

  @override
  Future<Either<Failure, List<TopRoomEntity>>> call(NoParams params) async {
    return await repository.getTopRooms();
  }
}

class NoParams {}


