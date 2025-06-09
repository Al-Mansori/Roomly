import 'package:roomly/features/room_management/domain/entities/amenity_entity.dart';

class AmenityModel extends AmenityEntity {
  const AmenityModel({
    required String id,
    String? name,
    String? type,
    String? description,
    int? totalCount,
    String? roomId,
  }) : super(
          id: id,
          name: name,
          type: type,
          description: description,
          totalCount: totalCount,
          roomId: roomId,
        );

  factory AmenityModel.fromJson(Map<String, dynamic> json) {
    return AmenityModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      type: json["type"] ?? "",
      description: json["description"] ?? "",
      totalCount: json["totalCount"],
      roomId: json["roomId"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "type": type,
      "description": description,
      "totalCount": totalCount,
      "roomId": roomId,
    };
  }
}


