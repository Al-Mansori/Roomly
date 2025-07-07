// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:roomly/features/home/domain/entities/workspace.dart';
// import 'package:roomly/features/home/presentation/screens/skeleton_room_screen.dart';
// import 'package:roomly/features/home/presentation/widget/room_card_for_types.dart';

// import '../../data/models/room_for_type_model.dart';
// import '../../domain/repositories/room_repo.dart';
// import '../bloc/cubit/room_cubit.dart';
// import '../bloc/state/room_state.dart' show RoomsErrorForType, RoomsLoadedForType, RoomsLoadingForType, RoomsState, RoomsStateForType;

// class RoomsScreen extends StatelessWidget {
//   final String roomType;

//   const RoomsScreen({super.key, required this.roomType});

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // Handle back button press
//         context.go('/home');
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('$roomType Rooms'),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () => context.go('/home'),
//           ),
//         ),
//         body: GestureDetector(
//           onHorizontalDragEnd: (details) {
//             // Handle swipe to go back
//             if (details.primaryVelocity! > 0) {
//               // Swiped from left to right
//               context.go('/home');
//             }
//           },
//           child: BlocProvider(
//             create: (context) => RoomsCubit(
//               roomRepository: context.read<RoomRepository>(),
//             )..fetchRoomsByType(roomType.toLowerCase()),
//             child: BlocBuilder<RoomsCubit, RoomsStateForType>(
//               builder: (context, state) {
//                 if (state is RoomsLoadingForType) {
//                   return ListView.builder(
//                     padding: const EdgeInsets.all(16),
//                     itemCount: 3,
//                     itemBuilder: (context, index) {
//                       return const Padding(
//                         padding: EdgeInsets.only(bottom: 16),
//                         child: RoomCardShimmer(),
//                       );
//                     },
//                   );
//                 } else if (state is RoomsErrorForType) {
//                   return Center(child: Text(state.message));
//                 } else if (state is RoomsLoadedForType) {
//                   return _buildRoomsList(state.rooms);
//                 }
//                 return const Center(child: Text('No rooms available'));
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRoomsList(List<RoomModelForType> apiRooms) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: apiRooms.length,
//       itemBuilder: (context, index) {
//         final RoomModelForType = apiRooms[index];
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 16),
//           child: RoomCardForTypes(
//             room: Room(
//               id: RoomModelForType.id,
//               name: RoomModelForType.name,
//               description: RoomModelForType.description,
//               pricePerHour: RoomModelForType.pricePerHour,
//               type: RoomModelForType.type,
//               capacity: RoomModelForType.capacity,
//               status: RoomModelForType.status,
//               images: RoomModelForType.images ?? [],
//               availableCount: RoomModelForType.availableCount,
//             ),
//             workspaceId: RoomModelForType.workspaceId,
//           ),
//         );
//       },
//     );
//   }
// }

// v2 ---------------------

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/home/domain/entities/workspace.dart';
import 'package:roomly/features/home/presentation/screens/skeleton_room_screen.dart';
import 'package:roomly/features/home/presentation/widget/room_card_for_types.dart';

import '../../data/models/room_for_type_model.dart';
import '../../domain/repositories/room_repo.dart';
import '../bloc/cubit/room_cubit.dart';
import '../bloc/state/room_state.dart' show RoomsErrorForType, RoomsLoadedForType, RoomsLoadingForType, RoomsState, RoomsStateForType;

class RoomsScreen extends StatelessWidget {
  final String roomType;

  const RoomsScreen({super.key, required this.roomType});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        context.go('/home');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('$roomType Rooms'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/home'),
          ),
        ),
        body: GestureDetector(
          onHorizontalDragEnd: (details) {
            // Handle swipe to go back
            if (details.primaryVelocity! > 0) {
              // Swiped from left to right
              context.go('/home');
            }
          },
          child: BlocProvider(
            create: (context) => RoomsCubit(
              roomRepository: context.read<RoomRepository>(),
            )..fetchRoomsByType(roomType.toLowerCase()),
            child: BlocBuilder<RoomsCubit, RoomsStateForType>(
              builder: (context, state) {
                if (state is RoomsLoadingForType) {
                  return const Center(
                    child: CircularProgressIndicator(), // Added circular indicator
                  );
                } else if (state is RoomsErrorForType) {
                  return Center(child: Text(state.message));
                } else if (state is RoomsLoadedForType) {
                  return _buildRoomsList(state.rooms);
                }
                return const Center(child: Text('No rooms available'));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoomsList(List<RoomModelForType> apiRooms) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: apiRooms.length,
      itemBuilder: (context, index) {
        final RoomModelForType = apiRooms[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: RoomCardForTypes(
            room: Room(
              id: RoomModelForType.id,
              name: RoomModelForType.name,
              description: RoomModelForType.description,
              pricePerHour: RoomModelForType.pricePerHour,
              type: RoomModelForType.type,
              capacity: RoomModelForType.capacity,
              status: RoomModelForType.status,
              images: RoomModelForType.images ?? [],
              availableCount: RoomModelForType.availableCount,
            ),
            workspaceId: RoomModelForType.workspaceId,
          ),
        );
      },
    );
  }
}