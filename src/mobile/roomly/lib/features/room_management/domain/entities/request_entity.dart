// features/request/domain/entities/request_entity.dart
class RequestEntity {
  final String id;
  final String type;
  final String details;
  final String userId;
  final String? staffId;
  final DateTime createdAt;

  RequestEntity({
    required this.id,
    required this.type,
    required this.details,
    required this.userId,
    this.staffId,
    required this.createdAt,
  });

  factory RequestEntity.fromJson(Map<String, dynamic> json) {
    return RequestEntity(
      id: json['id'],
      type: json['type'],
      details: json['details'],
      userId: json['userId'],
      staffId: json['staffId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}