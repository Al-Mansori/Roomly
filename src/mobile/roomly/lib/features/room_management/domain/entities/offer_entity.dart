import 'package:equatable/equatable.dart';

class OfferEntity extends Equatable {
  final String id;
  final String offerTitle;
  final String description;
  final double discountPercentage;
  final String validFrom;
  final String validTo;
  final String status;

  const OfferEntity({
    required this.id,
    required this.offerTitle,
    required this.description,
    required this.discountPercentage,
    required this.validFrom,
    required this.validTo,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        offerTitle,
        description,
        discountPercentage,
        validFrom,
        validTo,
        status,
      ];
}


