class Recommendation {
  final String workspaceId;
  final String name;
  final String description;
  final String city;
  final String town;
  final String type;
  final String priceRange;
  final double rating;
  final List<String> amenities;
  final String matchStatus;

  Recommendation({
    required this.workspaceId,
    required this.name,
    required this.description,
    required this.city,
    required this.town,
    required this.type,
    required this.priceRange,
    required this.rating,
    required this.amenities,
    required this.matchStatus,
  });
}
