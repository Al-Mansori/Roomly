// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:roomly/features/room_management/domain/usecases/get_room_details_usecase.dart';
// import 'package:roomly/features/room_management/domain/usecases/get_room_images_usecase.dart';
// import 'package:roomly/features/room_management/domain/usecases/get_room_offers_usecase.dart';
// import 'package:roomly/features/room_management/presentation/cubits/room_details_state.dart';
// import 'package:roomly/features/favorite/domain/usecases/get_favorite_rooms_usecase.dart';
// import 'package:roomly/features/favorite/domain/usecases/add_favorite_room_usecase.dart';
// import 'package:roomly/features/favorite/domain/usecases/remove_favorite_room_usecase.dart';

// import '../../../GlobalWidgets/app_session.dart';
// import '../../../auth/domain/entities/user_entity.dart';

// class RoomDetailsCubit extends Cubit<RoomDetailsState> {
//   final GetRoomDetailsUseCase getRoomDetailsUseCase;
//   final GetRoomImagesUseCase getRoomImagesUseCase;
//   final GetRoomOffersUseCase getRoomOffersUseCase;
//   final GetFavoriteRoomsUseCase getFavoriteRoomsUseCase;
//   final AddFavoriteRoomUseCase addFavoriteRoomUseCase;
//   final RemoveFavoriteRoomUseCase removeFavoriteRoomUseCase;

//   RoomDetailsCubit({
//     required this.getRoomDetailsUseCase,
//     required this.getRoomImagesUseCase,
//     required this.getRoomOffersUseCase,
//     required this.getFavoriteRoomsUseCase,
//     required this.addFavoriteRoomUseCase,
//     required this.removeFavoriteRoomUseCase,
//   }) : super(RoomDetailsInitial());

//   Future<void> getRoomDetails(String roomId) async {
//     emit(RoomDetailsLoading());
//     try {
//       final room = await getRoomDetailsUseCase(roomId);
//       final images = await getRoomImagesUseCase(roomId);
//       final offers = await getRoomOffersUseCase(roomId);
//       final UserEntity? user = AppSession().currentUser;

//       final userId = user?.id;
//       bool isFavorite = false;
//       if (userId != null) {
//         final favoriteRoomsEither = await getFavoriteRoomsUseCase(userId);
//         favoriteRoomsEither.fold(
//           (failure) => print('Failed to get favorite rooms: ${failure.message}'),
//           (favoriteRooms) {
//             isFavorite = favoriteRooms.any((favRoom) => favRoom.roomId == roomId);
//           },
//         );
//       }
//       emit(RoomDetailsLoaded(room: room, images: images, offers: offers, isFavorite: isFavorite));
//     } catch (e) {
//       emit(RoomDetailsError(message: e.toString()));
//     }
//   }

//   Future<void> toggleFavoriteStatus(String roomId, bool currentStatus) async {
//     final UserEntity? user = AppSession().currentUser;

//     final userId = user?.id;
//     if (userId == null) {
//       emit(const RoomDetailsError(message: 'User not logged in'));
//       return;
//     }

//     // Get current state to preserve room data
//     final currentState = state;
//     if (currentState is! RoomDetailsLoaded) {
//       emit(const RoomDetailsError(message: 'Room details not loaded'));
//       return;
//     }

//     if (currentStatus) {
//       // Currently favorite, so remove
//       final result = await removeFavoriteRoomUseCase(userId, roomId);
//       result.fold(
//         (failure) => emit(RoomDetailsError(message: 'Failed to remove from favorites: ${failure.message}')),
//         (_) => emit(RoomDetailsLoaded(
//           room: currentState.room,
//           images: currentState.images,
//           offers: currentState.offers,
//           isFavorite: false,
//         )),
//       );
//     } else {
//       // Not favorite, so add
//       final result = await addFavoriteRoomUseCase(AddFavoriteRoomParams(userId: userId, roomId: roomId));
//       result.fold(
//         (failure) => emit(RoomDetailsError(message: 'Failed to add to favorites: ${failure.message}')),
//         (_) => emit(RoomDetailsLoaded(
//           room: currentState.room,
//           images: currentState.images,
//           offers: currentState.offers,
//           isFavorite: true,
//         )),
//       );
//     }
//   }

// }




  
// // 

  

// v2 ===============================================================================



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomly/features/GlobalWidgets/app_session.dart';
import 'package:roomly/features/auth/data/models/user_model.dart';
import 'package:roomly/features/room_management/domain/usecases/get_room_details_usecase.dart';
import 'package:roomly/features/room_management/domain/usecases/get_room_images_usecase.dart';
import 'package:roomly/features/room_management/domain/usecases/get_room_offers_usecase.dart';
import 'package:roomly/features/room_management/presentation/cubits/room_details_state.dart';
import 'package:roomly/features/favorite/domain/usecases/get_favorite_rooms_usecase.dart';
import 'package:roomly/features/favorite/domain/usecases/add_favorite_room_usecase.dart';
import 'package:roomly/features/favorite/domain/usecases/remove_favorite_room_usecase.dart';
import 'package:roomly/features/room_management/domain/usecases/check_room_recovery_status_usecase.dart';

class RoomDetailsCubit extends Cubit<RoomDetailsState> {
  final GetRoomDetailsUseCase getRoomDetailsUseCase;
  final GetRoomImagesUseCase getRoomImagesUseCase;
  final GetRoomOffersUseCase getRoomOffersUseCase;
  final GetFavoriteRoomsUseCase getFavoriteRoomsUseCase;
  final AddFavoriteRoomUseCase addFavoriteRoomUseCase;
  final RemoveFavoriteRoomUseCase removeFavoriteRoomUseCase;
  final CheckRoomRecoveryStatusUseCase checkRoomRecoveryStatusUseCase;

  UserModel? _currentUser;

  RoomDetailsCubit({
    required this.getRoomDetailsUseCase,
    required this.getRoomImagesUseCase,
    required this.getRoomOffersUseCase,
    required this.getFavoriteRoomsUseCase,
    required this.addFavoriteRoomUseCase,
    required this.removeFavoriteRoomUseCase,
    required this.checkRoomRecoveryStatusUseCase,
  }) : super(RoomDetailsInitial());

  Future<void> getRoomDetails(String roomId) async {
    emit(RoomDetailsLoading());
    try {
      final room = await getRoomDetailsUseCase(roomId);
      final images = await getRoomImagesUseCase(roomId);
      final offers = await getRoomOffersUseCase(roomId);
      final isRecoveryMode = await checkRoomRecoveryStatusUseCase.execute(roomId);
      final userData = AppSession().currentUser;
      final userModel = UserModel.fromEntity(userData!);
      final userId = userModel.id;
      bool isFavorite = false;
      if (userId != null) {
        final favoriteRoomsEither = await getFavoriteRoomsUseCase(userId);
        favoriteRoomsEither.fold(
          (failure) => print('Failed to get favorite rooms: ${failure.message}'),
          (favoriteRooms) {
            isFavorite = favoriteRooms.any((favRoom) => favRoom.roomId == roomId);
          },
        );
      }
      emit(RoomDetailsLoaded(room: room, images: images, offers: offers, isFavorite: isFavorite, isRecoveryMode: isRecoveryMode));
    } catch (e) {
      emit(RoomDetailsError(message: e.toString()));
    }
  }

  Future<void> toggleFavoriteStatus(String roomId, bool currentStatus) async {
    final userData = AppSession().currentUser;
    final userModel = UserModel.fromEntity(userData!);
    final userId = userModel.id;
    if (userId == null) {
      emit(const RoomDetailsError(message: 'User not logged in'));
      return;
    }

    // Get current state to preserve room data
    final currentState = state;
    if (currentState is! RoomDetailsLoaded) {
      emit(const RoomDetailsError(message: 'Room details not loaded'));
      return;
    }

    if (currentStatus) {
      // Currently favorite, so remove
      final result = await removeFavoriteRoomUseCase(userId, roomId);
      result.fold(
        (failure) => emit(RoomDetailsError(message: 'Failed to remove from favorites: ${failure.message}')),
        (_) => emit(RoomDetailsLoaded(
          room: currentState.room,
          images: currentState.images,
          offers: currentState.offers,
          isFavorite: false,
          isRecoveryMode: currentState.isRecoveryMode,
        )),
      );
    } else {
      // Not favorite, so add
      final result = await addFavoriteRoomUseCase(AddFavoriteRoomParams(userId: userId, roomId: roomId));
      result.fold(
        (failure) => emit(RoomDetailsError(message: 'Failed to add to favorites: ${failure.message}')),
        (_) => emit(RoomDetailsLoaded(
          room: currentState.room,
          images: currentState.images,
          offers: currentState.offers,
          isFavorite: true,
          isRecoveryMode: currentState.isRecoveryMode,
        )),
      );
    }
  }
}


