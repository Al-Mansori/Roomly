import '../../domain/entities/card_entity.dart';

class CardModel extends CardEntity {
  const CardModel({
    required String userId,
    required String cardNumber,
  }) : super(
          userId: userId,
          cardNumber: cardNumber,
        );

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      userId: json['userId'] as String,
      cardNumber: json['cardNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'cardNumber': cardNumber,
    };
  }
}

class AddCardRequest {
  final String userId;
  final String cardNumber;
  final String cvv;
  final String endDate;

  const AddCardRequest({
    required this.userId,
    required this.cardNumber,
    required this.cvv,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'cardNumber': cardNumber,
      'cvv': cvv,
      'endDate': endDate,
    };
  }
}

