import 'package:equatable/equatable.dart';
import 'package:roomly/features/room_management/domain/entities/amenity_entity.dart';
import 'package:roomly/features/room_management/domain/entities/offer_entity.dart';
import 'package:roomly/features/workspace/domain/entities/image_entity.dart';

class RoomEntity extends Equatable {
  final String id;
  final String? name;
  final String? type;
  final String? description;
  final int? capacity;
  final int? availableCount;
  final double? pricePerHour;
  final String? roomStatus;
  final String? workspaceId;
  final List<AmenityEntity>? amenities;
  final List<ImageEntity>? roomImages;
  final List<OfferEntity>? offers;

  const RoomEntity({
    required this.id,
    this.name,
    this.type,
    this.description,
    this.capacity,
    this.availableCount,
    this.pricePerHour,
    this.roomStatus,
    this.workspaceId,
    this.amenities,
    this.roomImages,
    this.offers,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        description,
        capacity,
        availableCount,
        pricePerHour,
        roomStatus,
        workspaceId,
        amenities,
        roomImages,
        offers,
      ];
}


