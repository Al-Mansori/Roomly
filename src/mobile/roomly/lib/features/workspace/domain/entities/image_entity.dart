import 'package:equatable/equatable.dart';

class ImageEntity extends Equatable {
  final String imageUrl;
  final String? staffId;
  final String? workspaceId;
  final String? roomId;
  final String? amenityId;

  const ImageEntity({
    required this.imageUrl,
    this.staffId,
    this.workspaceId,
    this.roomId,
    this.amenityId,
  });

  @override
  List<Object?> get props => [
        imageUrl,
        staffId,
        workspaceId,
        roomId,
        amenityId,
      ];
}


