// lib/features/request/data/models/request_model.dart
import '../../domain/entities/request_entity.dart';

class RequestModel extends RequestEntity {
  RequestModel({
    required super.id,
    required super.type,
    required super.details,
    required super.userId,
    super.staffId,
    required super.createdAt,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'],
      type: json['type'],
      details: json['details'],
      userId: json['userId'],
      staffId: json['staffId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'details': details,
      'userId': userId,
      'staffId': staffId,
    };
  }
}