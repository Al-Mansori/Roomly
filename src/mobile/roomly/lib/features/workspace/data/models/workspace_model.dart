import 'package:roomly/features/workspace/domain/entities/workspace_entity.dart';
import 'package:roomly/features/workspace/data/models/location_model.dart';
import 'package:roomly/features/room_management/data/models/room_model.dart';
import 'package:roomly/features/workspace/data/models/image_model.dart';

class WorkspaceModel extends WorkspaceEntity {
  final LocationModel? location;
  final List<RoomModel>? rooms;
  final List<ImageModel>? workspaceImages;

  const WorkspaceModel({
    required String id,
    required String name,
    String? description,
    String? address,
    DateTime? createdDate,
    double? avgRating,
    String? type,
    this.location,
    this.rooms,
    this.workspaceImages,
  }) : super(
          id: id,
          name: name,
          description: description,
          address: address,
          createdDate: createdDate,
          avgRating: avgRating,
          type: type,
          location: location,
          rooms: rooms,
          workspaceImages: workspaceImages,
        );

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) {
    print("📥 Received JSON in fromJson: $json"); // ✅ هنا الطباعه

    final id = json["id"];
    final name = json["name"];

    if (id == null) {
      throw FormatException("Missing required field 'id' in Workspace JSON");
    }
    if (name == null) {
      throw FormatException("Missing required field 'name' in Workspace JSON");
    }

    return WorkspaceModel(
      id: id,
      name: name,
      description: json["description"],
      address: json["address"],
      createdDate: json["creationDate"] != null
          ? DateTime.parse(json["creationDate"])
          : null,
      avgRating: json["avgRating"]?.toDouble(),
      type: json["type"],
      location: json["location"] != null
          ? LocationModel.fromJson(json["location"])
          : null,
      rooms: (json["rooms"] as List<dynamic>?)
          ?.map((e) => RoomModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      workspaceImages: (json["workspaceImages"] as List<dynamic>?)
          ?.map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "address": address,
      "creationDate": createdDate?.toIso8601String(),
      "avgRating": avgRating,
      "type": type,
      "location": location?.toJson(),
      "rooms": rooms?.map((e) => e.toJson()).toList(),
      "workspaceImages": workspaceImages?.map((e) => e.toJson()).toList(),
    };
  }
}


