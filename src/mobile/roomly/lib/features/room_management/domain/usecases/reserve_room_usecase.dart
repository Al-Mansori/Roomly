import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository_impl.dart';

class ReserveRoomUseCase {
  final BookingRepository repository;

  ReserveRoomUseCase(this.repository);

  Future<Either<Failure, String>> call(BookingRequest request) async {
    return await repository.reserveRoom(request);
  }
}