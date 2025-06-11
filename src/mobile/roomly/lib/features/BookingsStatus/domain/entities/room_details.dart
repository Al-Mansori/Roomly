class RoomDetails {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  // ... other fields

  RoomDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory RoomDetails.fromJson(Map<String, dynamic> json) {
    String imageUrl = '';
    if (json['roomImages'] != null &&
        json['roomImages'] is List &&
        (json['roomImages'] as List).isNotEmpty) {
      final firstImage = (json['roomImages'] as List).first;
      if (firstImage is Map && firstImage['imageUrl'] != null) {
        imageUrl = firstImage['imageUrl'];
      }
    }
    return RoomDetails(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: imageUrl,
    );
  }
}
