
import 'package:equatable/equatable.dart';

import '../../../data/models/room_for_type_model.dart';
import '../../../data/models/workspace_model.dart';

abstract class RoomsStateForType extends Equatable {
  const RoomsStateForType();

  @override
  List<Object> get props => [];
}

class RoomsInitialForType extends RoomsStateForType {}

class RoomsLoadingForType extends RoomsStateForType {}

class RoomsLoadedForType extends RoomsStateForType {
  final List<RoomModelForType> rooms;

  const RoomsLoadedForType({required this.rooms});

  @override
  List<Object> get props => [rooms];
}

class RoomsErrorForType extends RoomsStateForType {
  final String message;

  const RoomsErrorForType({required this.message});

  @override
  List<Object> get props => [message];
}