import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
import 'package:roomly/features/room_management/data/models/amenity_model.dart';
import 'package:roomly/features/workspace/data/models/image_model.dart';

class RoomModel extends RoomEntity {
  const RoomModel({
    required String id,
    String? name,
    String? type,
    String? description,
    int? capacity,
    int? availableCount,
    double? pricePerHour,
    String? roomStatus,
    String? workspaceId,
    List<AmenityModel>? amenities,
    List<ImageModel>? roomImages,
  }) : super(
          id: id,
          name: name,
          type: type,
          description: description,
          capacity: capacity,
          availableCount: availableCount,
          pricePerHour: pricePerHour,
          roomStatus: roomStatus,
          workspaceId: workspaceId,
          amenities: amenities,
          roomImages: roomImages,
        );

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      type: json["type"] ?? "",
      description: json["description"] ?? "",
      capacity: json["capacity"],
      availableCount: json["availableCount"],
      pricePerHour: json["pricePerHour"]?.toDouble(),
      roomStatus: json["status"] ?? "",
      workspaceId: json["workspaceId"] ?? "",
      amenities: (json["amenities"] as List<dynamic>?)
          ?.map((e) => AmenityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      roomImages: (json["roomImages"] as List<dynamic>?)
          ?.map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "type": type,
      "description": description,
      "capacity": capacity,
      "availableCount": availableCount,
      "pricePerHour": pricePerHour,
      "status": roomStatus,
      "workspaceId": workspaceId,
      "amenities": (amenities as List<AmenityModel>?)?.map((e) => e.toJson()).toList(),
      "roomImages": (roomImages as List<ImageModel>?)?.map((e) => e.toJson()).toList(),
    };
  }
}


