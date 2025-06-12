

// Data Model
import 'package:roomly/features/loyalty/domain/entities/loyalty_points_entity.dart';

class LoyaltyPointsModel extends LoyaltyPointsEntity {
  const LoyaltyPointsModel({
    required super.totalPoints,
    required super.lastAddedPoint,
    required super.lastUpdatedDate,
    required super.userId,
  });

  factory LoyaltyPointsModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyPointsModel(
      totalPoints: json['TotalPoints'] as int? ?? json['totalPoints'] as int? ?? 0,
      lastAddedPoint: json['LastAddedPoint'] as int? ?? json['lastAddedPoint'] as int? ?? 0,
      lastUpdatedDate: json['LastUpdatedDate'] != null
          ? DateTime.parse(json['LastUpdatedDate'] as String)
          : json['lastUpdatedDate'] != null
              ? DateTime.parse(json['lastUpdatedDate'] as String)
              : DateTime.now(),
      userId: json['UserId'] as String? ?? json['userId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TotalPoints': totalPoints,
      'LastAddedPoint': lastAddedPoint,
      'LastUpdatedDate': lastUpdatedDate.toIso8601String(),
      'UserId': userId,
    };
  }

  LoyaltyPointsEntity toEntity() {
    return LoyaltyPointsEntity(
      totalPoints: totalPoints,
      lastAddedPoint: lastAddedPoint,
      lastUpdatedDate: lastUpdatedDate,
      userId: userId,
    );
  }

  factory LoyaltyPointsModel.fromEntity(LoyaltyPointsEntity entity) {
    return LoyaltyPointsModel(
      totalPoints: entity.totalPoints,
      lastAddedPoint: entity.lastAddedPoint,
      lastUpdatedDate: entity.lastUpdatedDate,
      userId: entity.userId,
    );
  }

  LoyaltyPointsModel copyWith({
    int? totalPoints,
    int? lastAddedPoint,
    DateTime? lastUpdatedDate,
    String? userId,
  }) {
    return LoyaltyPointsModel(
      totalPoints: totalPoints ?? this.totalPoints,
      lastAddedPoint: lastAddedPoint ?? this.lastAddedPoint,
      lastUpdatedDate: lastUpdatedDate ?? this.lastUpdatedDate,
      userId: userId ?? this.userId,
    );
  }
}

