import 'package:equatable/equatable.dart';

class AmenityEntity extends Equatable {
  final String id;
  final String? name;
  final String? type;
  final String? description;
  final int? totalCount;
  final String? roomId;

  const AmenityEntity({
    required this.id,
    this.name,
    this.type,
    this.description,
    this.totalCount,
    this.roomId,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        description,
        totalCount,
        roomId,
      ];
}


