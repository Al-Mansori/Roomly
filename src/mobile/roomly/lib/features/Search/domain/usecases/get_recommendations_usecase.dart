import '../entities/recommendation.dart';
import '../repositories/search_repository.dart';

class GetRecommendationsUseCase {
  final SearchRepository repository;
  GetRecommendationsUseCase(this.repository);

  Future<List<Recommendation>> call(String userId, {int topN = 5}) {
    return repository.getRecommendations(userId, topN: topN);
  }
}
