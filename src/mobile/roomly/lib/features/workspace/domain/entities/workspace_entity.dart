import 'package:equatable/equatable.dart';
import 'package:roomly/features/workspace/data/models/image_model.dart';
import 'package:roomly/features/workspace/data/models/location_model.dart';
import 'package:roomly/features/room_management/data/models/room_model.dart';

class WorkspaceEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? address;
  final DateTime? createdDate;
  final double? avgRating;
  final String? type;
  final String? locationId;

  const WorkspaceEntity({
    required this.id,
    required this.name,
    this.description,
    this.address,
    this.createdDate,
    this.avgRating,
    this.type,
    this.locationId, LocationModel? location, List<RoomModel>? rooms, List<ImageModel>? workspaceImages,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        address,
        createdDate,
        avgRating,
        type,
        locationId,
      ];

  get rooms => null;
}


