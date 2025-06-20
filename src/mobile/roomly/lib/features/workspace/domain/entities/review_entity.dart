import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final double rating;
  final String comment;
  final String reviewDate;
  final String userId;
  final String? userName;

  const ReviewEntity({
    required this.id,
    required this.rating,
    required this.comment,
    required this.reviewDate,
    required this.userId,
    this.userName,
  });

  ReviewEntity copyWith({
    String? id,
    double? rating,
    String? comment,
    String? reviewDate,
    String? userId,
    String? userName,
  }) {
    return ReviewEntity(
      id: id ?? this.id,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      reviewDate: reviewDate ?? this.reviewDate,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
    );
  }

  @override
  List<Object?> get props => [id, rating, comment, reviewDate, userId, userName];
}


