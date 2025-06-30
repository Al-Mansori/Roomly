import '../../domain/entities/recommendation.dart';

class RecommendationModel extends Recommendation {
  RecommendationModel({
    required super.workspaceId,
    required super.name,
    required super.description,
    required super.city,
    required super.town,
    required super.type,
    required super.priceRange,
    required super.rating,
    required super.amenities,
    required super.matchStatus,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      workspaceId: json['workspace_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      city: json['city'] ?? '',
      town: json['town'] ?? '',
      type: json['type'] ?? '',
      priceRange: json['price_range'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      amenities: List<String>.from(json['amenities'] ?? []),
      matchStatus: json['match_status'] ?? '',
    );
  }
}
