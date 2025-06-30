import '../../domain/entities/search_result.dart';
import '../../domain/entities/filter_params.dart';
import '../../domain/repositories/search_repository.dart';
import '../data_sources/search_remote_data_source.dart';
import '../models/search_result_model.dart';
import '../data_sources/recommendation_remote_data_source.dart';
import '../models/recommendation_model.dart';
import '../../domain/entities/recommendation.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final RecommendationRemoteDataSource recommendationRemoteDataSource;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.recommendationRemoteDataSource,
  });

  @override
  Future<SearchResultModel> search(String query) async {
    try {
      return await remoteDataSource.search(query);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Room>> filterRooms(FilterParams filterParams) async {
    try {
      final roomModels = await remoteDataSource.filterRooms(filterParams);
      return roomModels.cast<Room>();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Recommendation>> getRecommendations(String userId,
      {int topN = 5}) async {
    try {
      return await recommendationRemoteDataSource.getRecommendations(
          userId: userId, topN: topN);
    } catch (e) {
      rethrow;
    }
  }
}
