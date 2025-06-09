import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
import 'package:roomly/features/workspace/presentation/cubits/workspace_details_cubit.dart';

class WorkspaceListingsScreen extends StatelessWidget {
  const WorkspaceListingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceDetailsCubit, WorkspaceDetailsState>(
      builder: (context, state) {
        if (state is WorkspaceDetailsLoaded) {
          final workspace = state.workspace;
          if (workspace.rooms == null || workspace.rooms!.isEmpty) {
            return const Center(child: Text('No rooms available for this workspace.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: workspace.rooms!.length,
            itemBuilder: (context, index) {
              final room = workspace.rooms![index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildRoomItem(context, room),
              );
            },
          );
        } else if (state is WorkspaceDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WorkspaceDetailsError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('Load workspace details to see rooms.'));
        }
      },
    );
  }

  Widget _buildRoomItem(BuildContext context, RoomEntity room) {
    return GestureDetector(
      onTap: () {
        // Navigate to RoomDetailsScreen when a room card is tapped
        context.push('/room/${room.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    room.roomImages != null && room.roomImages!.isNotEmpty
                        ? room.roomImages!.first.imageUrl
                        : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSfEaPJnw699oCoMuHAfPthvTPs2LmKx6sTQ&s',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Favorite button on image
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border,
                          size: 18, color: Colors.grey),
                      onPressed: () {
                        // Favorite action
                      },
                    ),
                  ),
                ),
              ],
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.name ?? 'N/A',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${room.capacity ?? 'N/A'} Seats',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Price and Book now button
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${room.pricePerHour?.toStringAsFixed(2) ?? 'N/A'} /Hour',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ElevatedButton(
                        onPressed: () {
                          // Book action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


