// import 'package:equatable/equatable.dart';
// import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
// import 'package:roomly/features/room_management/domain/entities/offer_entity.dart';
// import 'package:roomly/features/workspace/domain/entities/image_entity.dart';

// abstract class RoomDetailsState extends Equatable {
//   const RoomDetailsState();

//   @override
//   List<Object?> get props => [];
// }

// class RoomDetailsInitial extends RoomDetailsState {}

// class RoomDetailsLoading extends RoomDetailsState {}

// class RoomDetailsLoaded extends RoomDetailsState {
//   final RoomEntity room;
//   final List<ImageEntity> images;
//   final List<OfferEntity> offers;

//   const RoomDetailsLoaded({
//     required this.room,
//     required this.images,
//     required this.offers,
//   });

//   @override
//   List<Object?> get props => [room, images, offers];
// }

// class RoomDetailsError extends RoomDetailsState {
//   final String message;

//   const RoomDetailsError({required this.message});

//   @override
//   List<Object?> get props => [message];
// }




// v5 ------------------------------------------------------------------------------




// import 'package:equatable/equatable.dart';
// import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
// import 'package:roomly/features/room_management/domain/entities/offer_entity.dart';
// import 'package:roomly/features/workspace/domain/entities/image_entity.dart';

// abstract class RoomDetailsState extends Equatable {
//   const RoomDetailsState();

//   @override
//   List<Object?> get props => [];
// }

// class RoomDetailsInitial extends RoomDetailsState {}

// class RoomDetailsLoading extends RoomDetailsState {}

// class RoomDetailsLoaded extends RoomDetailsState {
//   final RoomEntity room;
//   final List<ImageEntity> images;
//   final List<OfferEntity> offers;
//   final bool isFavorite;

//   const RoomDetailsLoaded({
//     required this.room,
//     required this.images,
//     required this.offers,
//     required this.isFavorite,
//   });

//   @override
//   List<Object?> get props => [room, images, offers, isFavorite];
// }

// class RoomDetailsError extends RoomDetailsState {
//   final String message;

//   const RoomDetailsError({required this.message});

//   @override
//   List<Object?> get props => [message];
// }



// class RoomDetailsFavoriteStatusChanged extends RoomDetailsState {
//   final bool isFavorite;

//   const RoomDetailsFavoriteStatusChanged({required this.isFavorite});

//   @override
//   List<Object?> get props => [isFavorite];
// }



// v6 ------------------------------------------------------------------------------


import 'package:equatable/equatable.dart';
import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
import 'package:roomly/features/room_management/domain/entities/offer_entity.dart';
import 'package:roomly/features/workspace/domain/entities/image_entity.dart';

abstract class RoomDetailsState extends Equatable {
  const RoomDetailsState();

  @override
  List<Object?> get props => [];
}

class RoomDetailsInitial extends RoomDetailsState {}

class RoomDetailsLoading extends RoomDetailsState {}

class RoomDetailsLoaded extends RoomDetailsState {
  final RoomEntity room;
  final List<ImageEntity> images;
  final List<OfferEntity> offers;
  final bool isFavorite;

  const RoomDetailsLoaded({
    required this.room,
    required this.images,
    required this.offers,
    required this.isFavorite,
  });

  @override
  List<Object?> get props => [room, images, offers, isFavorite];
}

class RoomDetailsError extends RoomDetailsState {
  final String message;

  const RoomDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}

