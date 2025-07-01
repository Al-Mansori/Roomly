
import 'package:roomly/features/room_management/domain/entities/offer_entity.dart';

class OfferModel extends OfferEntity {
  const OfferModel({
    required String id,
    required String offerTitle,
    required String description,
    required double discountPercentage,
    required String validFrom,
    required String validTo,
    required String status,
  }) : super(
          id: id,
          offerTitle: offerTitle,
          description: description,
          discountPercentage: discountPercentage,
          validFrom: validFrom,
          validTo: validTo,
          status: status,
        );

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json["id"] ?? "",
      offerTitle: json["offerTitle"] ?? "",
      description: json["description"] ?? "",
      discountPercentage: json["discountPercentage"]?.toDouble() ?? 0.0,
      validFrom: json["validFrom"] ?? "",
      validTo: json["validTo"] ?? "",
      status: json["status"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "offerTitle": offerTitle,
      "description": description,
      "discountPercentage": discountPercentage,
      "validFrom": validFrom,
      "validTo": validTo,
      "status": status,
    };
  }
}


