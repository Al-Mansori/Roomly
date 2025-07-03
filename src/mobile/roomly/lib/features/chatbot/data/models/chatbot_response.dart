// import 'chatbot_room.dart';

// class ExtractedRequirements {
//   final List<String> amenities;
//   final String paymentType;
//   final int priceRangeMax;
//   final int priceRangeMin;
//   final String roomType;
//   final int seatsNeeded;
//   final int workspaceRatingMin;

//   ExtractedRequirements({
//     required this.amenities,
//     required this.paymentType,
//     required this.priceRangeMax,
//     required this.priceRangeMin,
//     required this.roomType,
//     required this.seatsNeeded,
//     required this.workspaceRatingMin,
//   });

//   factory ExtractedRequirements.fromJson(Map<String, dynamic> json) {
//     return ExtractedRequirements(
//       amenities: List<String>.from(json['amenities'] ?? []),
//       paymentType: json['payment_type'] ?? '',
//       priceRangeMax: json['price_range_max'] ?? 0,
//       priceRangeMin: json['price_range_min'] ?? 0,
//       roomType: json['room_type'] ?? '',
//       seatsNeeded: json['seats_needed'] ?? 0,
//       workspaceRatingMin: json['workspace_rating_min'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'amenities': amenities,
//       'payment_type': paymentType,
//       'price_range_max': priceRangeMax,
//       'price_range_min': priceRangeMin,
//       'room_type': roomType,
//       'seats_needed': seatsNeeded,
//       'workspace_rating_min': workspaceRatingMin,
//     };
//   }
// }

// class ChatbotResponse {
//   final ExtractedRequirements extractedRequirements;
//   final String message;
//   final List<Room> rooms;

//   ChatbotResponse({
//     required this.extractedRequirements,
//     required this.message,
//     required this.rooms,
//   });

//   factory ChatbotResponse.fromJson(Map<String, dynamic> json) {
//     return ChatbotResponse(
//       extractedRequirements: ExtractedRequirements.fromJson(json['extracted_requirements'] ?? {}),
//       message: json['message'] ?? '',
//       rooms: (json['rooms'] as List? ?? [])
//           .map((room) => Room.fromJson(room))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'extracted_requirements': extractedRequirements.toJson(),
//       'message': message,
//       'rooms': rooms.map((room) => room.toJson()).toList(),
//     };
//   }
// }



// v2 ------------------------------------------------------------------------------



import 'chatbot_room.dart';

class ExtractedRequirements {
  final List<String> amenities;
  final String paymentType;
  final int priceRangeMax;
  final int priceRangeMin;
  final String roomType;
  final int seatsNeeded;
  final int workspaceRatingMin;

  ExtractedRequirements({
    required this.amenities,
    required this.paymentType,
    required this.priceRangeMax,
    required this.priceRangeMin,
    required this.roomType,
    required this.seatsNeeded,
    required this.workspaceRatingMin,
  });

  factory ExtractedRequirements.fromJson(Map<String, dynamic> json) {
    return ExtractedRequirements(
      amenities: List<String>.from(json['amenities'] ?? []),
      paymentType: json['payment_type'] ?? '',
      priceRangeMax: (json['price_range_max'] as num?)?.toInt() ?? 0,
      priceRangeMin: (json['price_range_min'] as num?)?.toInt() ?? 0,
      roomType: json['room_type'] ?? '',
      seatsNeeded: (json['seats_needed'] as num?)?.toInt() ?? 0,
      workspaceRatingMin: (json['workspace_rating_min'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amenities': amenities,
      'payment_type': paymentType,
      'price_range_max': priceRangeMax,
      'price_range_min': priceRangeMin,
      'room_type': roomType,
      'seats_needed': seatsNeeded,
      'workspace_rating_min': workspaceRatingMin,
    };
  }
}

class ChatbotResponse {
  final ExtractedRequirements extractedRequirements;
  final String message;
  final List<Room> rooms;

  ChatbotResponse({
    required this.extractedRequirements,
    required this.message,
    required this.rooms,
  });

  factory ChatbotResponse.fromJson(Map<String, dynamic> json) {
    return ChatbotResponse(
      extractedRequirements: ExtractedRequirements.fromJson(json['extracted_requirements'] ?? {}),
      message: json['message'] ?? '',
      rooms: (json['rooms'] as List? ?? [])
          .map((room) => Room.fromJson(room))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'extracted_requirements': extractedRequirements.toJson(),
      'message': message,
      'rooms': rooms.map((room) => room.toJson()).toList(),
    };
  }
}

