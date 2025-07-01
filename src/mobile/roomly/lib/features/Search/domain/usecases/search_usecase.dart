import '../entities/search_result.dart';
import '../repositories/search_repository.dart';
import '../../data/models/search_result_model.dart';

class SearchUseCase {
  final SearchRepository repository;

  SearchUseCase({required this.repository});

  Future<SearchResultModel> call(String query) async {
    return await repository.search(query);
  }
}
