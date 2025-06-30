import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recommendation_model.dart';

class RecommendationRemoteDataSource {
  Future<List<RecommendationModel>> getRecommendations(
      {required String userId, int topN = 5}) async {
    final url = Uri.parse(
        'https://mostafaabdelkawy-roomly-ai.hf.space/api/v1/recommendations/preferences?user_id=$userId&top_n=$topN');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final recs = data['data']['recommendations'] as List<dynamic>?;
      if (recs != null) {
        return recs.map((e) => RecommendationModel.fromJson(e)).toList();
      }
      return [];
    } else {
      throw Exception('Failed to load recommendations');
    }
  }
}
