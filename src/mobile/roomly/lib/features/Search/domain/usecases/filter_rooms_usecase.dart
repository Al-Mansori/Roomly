import '../entities/search_result.dart';
import '../entities/filter_params.dart';
import '../repositories/search_repository.dart';

class FilterRoomsUseCase {
  final SearchRepository repository;

  FilterRoomsUseCase({required this.repository});

  Future<List<Room>> call(FilterParams filterParams) async {
    return await repository.filterRooms(filterParams);
  }
}
