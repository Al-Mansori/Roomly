import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomly/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:roomly/features/favorite/presentation/cubit/favorite_state.dart';
import 'package:roomly/features/favorite/presentation/widgets/room_card_widget.dart';

import '../../../GlobalWidgets/app_session.dart';
import '../../../GlobalWidgets/navBar.dart';
import '../../../auth/domain/entities/user_entity.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  String? _userId;
  bool _isLoadingUserId = true;
  String? _userIdError;
  final ScrollController _scrollController = ScrollController();
  bool _isScrollingDown = false;
  bool _isNavVisible = true;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (!_isScrollingDown) {
        setState(() {
          _isScrollingDown = true;
          _isNavVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward ||
        _scrollController.position.atEdge) {
      setState(() {
        _isScrollingDown = false;
        _isNavVisible = true;
      });
    }
  }

  Future<void> _fetchUserId() async {
    try {
      final UserEntity? user = AppSession().currentUser;
      final id = user?.id;
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
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _isLoadingUserId
              ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
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
                return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
              } else if (state is FavoriteLoaded) {
                if (state.favoriteRooms.isEmpty) {
                  return const Center(child: Text('No favorite rooms yet.', style: TextStyle(fontSize: 16, color: Colors.grey)));
                }
                return ListView.builder(
                  controller: _scrollController, // Add scroll controller here
                  padding: const EdgeInsets.all(8.0).add(EdgeInsets.only(bottom: 80)), // Add extra bottom padding for navbar
                  itemCount: state.favoriteRooms.length,
                  itemBuilder: (context, index) {
                    final favoriteRoom = state.favoriteRooms[index];
                    return RoomCardWidget(
                      roomId: favoriteRoom.roomId,
                      workspaceId: favoriteRoom.workspaceId,
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
                return Center(child: Text('Error: ${state.message}', style: TextStyle(color: Colors.red)));
              }
              return const Center(child: Text('Loading favorite rooms...', style: TextStyle(fontSize: 16, color: Colors.grey)));
            },
          ),
          // Add the navbar widget here
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            bottom: MediaQuery.of(context).viewInsets.bottom > 0
                ? -100
                : (_isNavVisible ? 20 : -80),
            left: 20,
            right: 20,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isNavVisible && MediaQuery.of(context).viewInsets.bottom == 0
                  ? 1.0
                  : 0.0,
              child: BottomNavBar(), // Make sure to import your BottomNavBar widget
            ),
          ),
        ],
      ),
    );
  }
}