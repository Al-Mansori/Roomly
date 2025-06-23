// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dio/dio.dart';
// import 'package:roomly/features/favorite/data/repository/favorite_repository_impl.dart';
// import '../../data/data_source/favorite_remote_data_source.dart';
// import '../../domain/usecases/get_favorite_rooms_usecase.dart';
// import '../../domain/usecases/remove_favorite_room_usecase.dart';
// import '../cubit/favorite_cubit.dart';
// import '../cubit/favorite_state.dart';
// import '../widgets/room_card_widget.dart';

// class FavoriteScreen extends StatelessWidget {
//   final String userId;

//   const FavoriteScreen({Key? key, required this.userId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => FavoriteCubit(
//         getFavoriteRoomsUseCase: GetFavoriteRoomsUseCase(
//           FavoriteRepositoryImpl(
//             remoteDataSource: FavoriteRemoteDataSourceImpl(dio: Dio()),
//           ),
//         ),
//         removeFavoriteRoomUseCase: RemoveFavoriteRoomUseCase(
//           FavoriteRepositoryImpl(
//             remoteDataSource: FavoriteRemoteDataSourceImpl(dio: Dio()),
//           ),
//         ),
//       )..getFavoriteRooms(userId),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Favorite Rooms'),
//         ),
//         body: BlocConsumer<FavoriteCubit, FavoriteState>(
//           listener: (context, state) {
//             if (state is FavoriteRoomRemoved) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Room ${state.roomId} removed from favorites')),
//               );
//               context.read<FavoriteCubit>().getFavoriteRooms(userId);
//             }
//           },
//           builder: (context, state) {
//             if (state is FavoriteLoading) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is FavoriteLoaded) {
//               if (state.favoriteRooms.isEmpty) {
//                 return const Center(child: Text('No favorite rooms yet.'));
//               }
//               return ListView.builder(
//                 itemCount: state.favoriteRooms.length,
//                 itemBuilder: (context, index) {
//                   final favoriteRoom = state.favoriteRooms[index];
//                   return RoomCardWidget(
//                     roomId: favoriteRoom.roomId,
//                     onFavoriteToggle: () {
//                       context.read<FavoriteCubit>().removeFavoriteRoom(
//                             userId,
//                             favoriteRoom.roomId,
//                           );
//                     },
//                     isFavorite: true,
//                   );
//                 },
//               );
//             } else if (state is FavoriteError) {
//               return Center(child: Text('Error: ${state.message}'));
//             }
//             return const Center(child: Text('Press the button to load favorites'));
//           },
//         ),
//       ),
//     );
//   }
// }



// v2 -----------------------------------------------------------------------------------



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:roomly/features/auth/data/data_sources/secure_storage.dart';
// import 'package:roomly/features/favorite/presentation/cubit/favorite_cubit.dart';
// import 'package:roomly/features/favorite/presentation/cubit/favorite_state.dart';
// import 'package:roomly/features/favorite/presentation/widgets/room_card_widget.dart';

// class FavoriteScreen extends StatefulWidget {
//   const FavoriteScreen({Key? key}) : super(key: key);

//   @override
//   State<FavoriteScreen> createState() => _FavoriteScreenState();
// }

// class _FavoriteScreenState extends State<FavoriteScreen> {
//   String? _userId;
//   bool _isLoadingUserId = true;
//   String? _userIdError;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserId();
//   }

//   Future<void> _fetchUserId() async {
//     try {
//       final id = await SecureStorage.getId();
//       if (id != null) {
//         setState(() {
//           _userId = id;
//           _isLoadingUserId = false;
//         });
//         // Once userId is available, trigger fetching favorite rooms
//         if (mounted) {
//           context.read<FavoriteCubit>().getFavoriteRooms(_userId!); 
//         }
//       } else {
//         setState(() {
//           _userIdError = 'User ID not found. Please log in.';
//           _isLoadingUserId = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _userIdError = 'Error fetching user ID: $e';
//         _isLoadingUserId = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Favorite Rooms'),
//       ),
//       body: _isLoadingUserId
//           ? const Center(child: CircularProgressIndicator())
//           : _userIdError != null
//               ? Center(child: Text(_userIdError!))
//               : BlocConsumer<FavoriteCubit, FavoriteState>(
//                   listener: (context, state) {
//                     if (state is FavoriteRoomRemoved) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Room ${state.roomId} removed from favorites')),
//                       );
//                       // Re-fetch favorite rooms after removal
//                       if (_userId != null) {
//                         context.read<FavoriteCubit>().getFavoriteRooms(_userId!); 
//                       }
//                     }
//                   },
//                   builder: (context, state) {
//                     if (state is FavoriteLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (state is FavoriteLoaded) {
//                       if (state.favoriteRooms.isEmpty) {
//                         return const Center(child: Text('No favorite rooms yet.'));
//                       }
//                       return ListView.builder(
//                         itemCount: state.favoriteRooms.length,
//                         itemBuilder: (context, index) {
//                           final favoriteRoom = state.favoriteRooms[index];
//                           return RoomCardWidget(
//                             roomId: favoriteRoom.roomId,
//                             onFavoriteToggle: () {
//                               if (_userId != null) {
//                                 context.read<FavoriteCubit>().removeFavoriteRoom(
//                                       _userId!,
//                                       favoriteRoom.roomId,
//                                     );
//                               }
//                             },
//                             isFavorite: true,
//                           );
//                         },
//                       );
//                     } else if (state is FavoriteError) {
//                       return Center(child: Text('Error: ${state.message}'));
//                     }
//                     return const Center(child: Text('Loading favorite rooms...'));
//                   },
//                 ),
//     );
//   }
// }


// v3 -----------------------------------------------------------------------------------


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomly/features/auth/data/data_sources/secure_storage.dart';
import 'package:roomly/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:roomly/features/favorite/presentation/cubit/favorite_state.dart';
import 'package:roomly/features/favorite/presentation/widgets/room_card_widget.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  String? _userId;
  bool _isLoadingUserId = true;
  String? _userIdError;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    try {
      final id = await SecureStorage.getId();
      if (id != null) {
        setState(() {
          _userId = id;
          _isLoadingUserId = false;
        });
        // Once userId is available, trigger fetching favorite rooms
        if (mounted) {
          context.read<FavoriteCubit>().getFavoriteRooms(_userId!); 
        }
      } else {
        setState(() {
          _userIdError = 'User ID not found. Please log in.';
          _isLoadingUserId = false;
        });
      }
    } catch (e) {
      setState(() {
        _userIdError = 'Error fetching user ID: $e';
        _isLoadingUserId = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Rooms',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent, // Accent blue theme
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoadingUserId
          ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent,))
          : _userIdError != null
              ? Center(child: Text(_userIdError!))
              : BlocConsumer<FavoriteCubit, FavoriteState>(
                  listener: (context, state) {
                    if (state is FavoriteRoomRemoved) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Room ${state.roomId} removed from favorites')),
                      );
                      // Re-fetch favorite rooms after removal
                      if (_userId != null) {
                        context.read<FavoriteCubit>().getFavoriteRooms(_userId!); 
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is FavoriteLoading) {
                      return const Center(child: CircularProgressIndicator(color: Colors.blueAccent,));
                    } else if (state is FavoriteLoaded) {
                      if (state.favoriteRooms.isEmpty) {
                        return const Center(child: Text('No favorite rooms yet.', style: TextStyle(fontSize: 16, color: Colors.grey),));
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(8.0), // Add padding to the list
                        itemCount: state.favoriteRooms.length,
                        itemBuilder: (context, index) {
                          final favoriteRoom = state.favoriteRooms[index];
                          return RoomCardWidget(
                            roomId: favoriteRoom.roomId,
                            onFavoriteToggle: () {
                              if (_userId != null) {
                                context.read<FavoriteCubit>().removeFavoriteRoom(
                                      _userId!,
                                      favoriteRoom.roomId,
                                    );
                              }
                            },
                            isFavorite: true,
                          );
                        },
                      );
                    } else if (state is FavoriteError) {
                      return Center(child: Text('Error: ${state.message}', style: TextStyle(color: Colors.red),));
                    }
                    return const Center(child: Text('Loading favorite rooms...', style: TextStyle(fontSize: 16, color: Colors.grey),));
                  },
                ),
    );
  }
}

