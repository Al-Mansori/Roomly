import 'package:equatable/equatable.dart';

class CardEntity extends Equatable {
  final String userId;
  final String cardNumber;

  const CardEntity({
    required this.userId,
    required this.cardNumber,
  });

  @override
  List<Object> get props => [userId, cardNumber];

  String get maskedCardNumber {
    if (cardNumber.length >= 4) {
      final lastFour = cardNumber.substring(cardNumber.length - 4);
      final masked = '*' * (cardNumber.length - 4) + lastFour;
      return masked.replaceAllMapped(
        RegExp(r'.{4}'),
        (match) => '${match.group(0)} ',
      ).trim();
    }
    return cardNumber;
  }

  String get formattedCardNumber {
    return cardNumber.replaceAllMapped(
      RegExp(r'.{4}'),
      (match) => '${match.group(0)} ',
    ).trim();
  }
}

