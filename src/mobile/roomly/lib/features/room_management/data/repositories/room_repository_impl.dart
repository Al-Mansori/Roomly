// import 'package:roomly/features/room_management/data/data_sources/room_remote_data_source.dart';
// import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
// import 'package:roomly/features/room_management/domain/repositories/room_repository.dart';
// import 'package:roomly/features/workspace/domain/entities/image_entity.dart';

// class RoomRepositoryImpl implements RoomRepository {
//   final RoomRemoteDataSource remoteDataSource;

//   RoomRepositoryImpl({required this.remoteDataSource});

//   @override
//   Future<RoomEntity> getRoomDetails(String roomId) async {
//     final roomModel = await remoteDataSource.getRoomDetails(roomId);
//     return roomModel;
//   }

//   @override
//   Future<List<ImageEntity>> getRoomImages(String roomId) async {
//     final imageModels = await remoteDataSource.getRoomImages(roomId);
//     return imageModels;
//   }
// }


// v2 ------------------------------------------------------------------------------------


import 'package:roomly/features/room_management/data/data_sources/room_remote_data_source.dart';
import 'package:roomly/features/room_management/data/data_sources/offer_remote_data_source.dart';
import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
import 'package:roomly/features/room_management/domain/entities/offer_entity.dart';
import 'package:roomly/features/room_management/domain/repositories/room_repository.dart';
import 'package:roomly/features/workspace/domain/entities/image_entity.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource remoteDataSource;
  final OfferRemoteDataSource offerRemoteDataSource;

  RoomRepositoryImpl({
    required this.remoteDataSource,
    required this.offerRemoteDataSource,
  });

  @override
  Future<RoomEntity> getRoomDetails(String roomId) async {
    final roomModel = await remoteDataSource.getRoomDetails(roomId);
    return roomModel;
  }

  @override
  Future<List<ImageEntity>> getRoomImages(String roomId) async {
    final imageModels = await remoteDataSource.getRoomImages(roomId);
    return imageModels;
  }

  @override
  Future<List<OfferEntity>> getRoomOffers(String roomId) async {
    final offerModels = await offerRemoteDataSource.getRoomOffers(roomId);
    return offerModels;
  }
}


