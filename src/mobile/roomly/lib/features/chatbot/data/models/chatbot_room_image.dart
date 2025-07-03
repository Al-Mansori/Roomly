class RoomImage {
  final String imageUrl;

  RoomImage({required this.imageUrl});

  factory RoomImage.fromJson(Map<String, dynamic> json) {
    return RoomImage(
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
    };
  }
}

