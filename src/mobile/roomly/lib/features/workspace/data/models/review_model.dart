import 'package:roomly/features/workspace/domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required String id,
    required double rating,
    required String comment,
    required String reviewDate,
    required String userId,
    String? userName,
  }) : super(
          id: id,
          rating: rating,
          comment: comment,
          reviewDate: reviewDate,
          userId: userId,
          userName: userName,
        );

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      reviewDate: json['reviewDate'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'comment': comment,
      'reviewDate': reviewDate,
      'userId': userId,
      'userName': userName,
    };
  }
}


