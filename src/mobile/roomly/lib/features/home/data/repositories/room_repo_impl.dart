// lib/features/rooms/data/repositories/room_repository_impl.dart

import 'package:roomly/features/home/data/models/room_for_type_model.dart';

import '../../domain/repositories/room_repo.dart';
import '../data_sources/room_remote_datasource.dart';
import '../models/workspace_model.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource remoteDataSource;

  RoomRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<RoomModelForType>> getRoomsByType(String type) async {
    return await remoteDataSource.getRoomsByType(type);
  }
}