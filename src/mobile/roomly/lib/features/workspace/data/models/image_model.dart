import 'package:roomly/features/workspace/domain/entities/image_entity.dart';

class ImageModel extends ImageEntity {
  const ImageModel({
    required String imageUrl,
    String? staffId,
    String? workspaceId,
    String? roomId,
    String? amenityId,
  }) : super(
          imageUrl: imageUrl,
          staffId: staffId,
          workspaceId: workspaceId,
          roomId: roomId,
          amenityId: amenityId,
        );

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      imageUrl: json["imageUrl"],
      staffId: json["staffId"],
      workspaceId: json["workspaceId"],
      roomId: json["roomId"],
      amenityId: json["amenityId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "imageUrl": imageUrl,
      "staffId": staffId,
      "workspaceId": workspaceId,
      "roomId": roomId,
      "amenityId": amenityId,
    };
  }
}


