// Domain Entity
class LoyaltyPointsEntity {
  final int totalPoints;
  final int lastAddedPoint;
  final DateTime lastUpdatedDate;
  final String userId;

  const LoyaltyPointsEntity({
    required this.totalPoints,
    required this.lastAddedPoint,
    required this.lastUpdatedDate,
    required this.userId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoyaltyPointsEntity &&
        other.totalPoints == totalPoints &&
        other.lastAddedPoint == lastAddedPoint &&
        other.lastUpdatedDate == lastUpdatedDate &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return totalPoints.hashCode ^
        lastAddedPoint.hashCode ^
        lastUpdatedDate.hashCode ^
        userId.hashCode;
  }

  @override
  String toString() {
    return 'LoyaltyPointsEntity(totalPoints: $totalPoints, lastAddedPoint: $lastAddedPoint, lastUpdatedDate: $lastUpdatedDate, userId: $userId)';
  }
}

