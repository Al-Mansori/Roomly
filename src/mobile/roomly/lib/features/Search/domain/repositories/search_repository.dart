import '../entities/search_result.dart';
import '../entities/filter_params.dart';
import '../entities/recommendation.dart';
import '../../data/models/search_result_model.dart';

abstract class SearchRepository {
  Future<SearchResultModel> search(String query);
  Future<List<Room>> filterRooms(FilterParams filterParams);
  Future<List<Recommendation>> getRecommendations(String userId,
      {int topN = 5});
  Future<Workspace> getWorkspaceDetails(String workspaceId);
}
