import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/favorite_cubit.dart';
import '../../domain/entities/favorite_room.dart';
import '../widgets/favorite_room_card.dart';

class FavoriteScreen extends StatelessWidget {
  final String userId;
  const FavoriteScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite')),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoriteLoaded) {
            if (state.rooms.isEmpty) {
              return const Center(child: Text('No favorites yet.'));
            }
            return ListView.builder(
              itemCount: state.rooms.length,
              itemBuilder: (context, index) {
                return FavoriteRoomCard(
                    room: state.rooms[index], userId: userId);
              },
            );
          } else if (state is FavoriteError) {
            return Center(child: Text('Error: \\${state.message}'));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
