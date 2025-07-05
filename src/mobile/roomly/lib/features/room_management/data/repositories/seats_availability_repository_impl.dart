import '../../domain/entities/seats_availability_entity.dart';
import '../../domain/repositories/seats_repository.dart';
import '../data_sources/seats_availability_remote_data_source.dart';

class SeatsAvailabilityRepositoryImpl implements SeatsAvailabilityRepository {
  final SeatsAvailabilityRemoteDataSource remoteDataSource;

  SeatsAvailabilityRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<SeatsAvailability>> checkAvailability({
    required String roomId,
    required DateTime date,
  }) async {
    final models = await remoteDataSource.checkAvailability(
      roomId: roomId,
      date: date,
    );
    return models.map((model) => model.toEntity()).toList();
  }
}