import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomly/features/home/presentation/widget/room_card.dart';
import 'package:roomly/features/home/presentation/widget/section_title.dart';

import '../bloc/cubit/workspace_cubit.dart';

class RecommendedRooms extends StatelessWidget {
  const RecommendedRooms({super.key});

  @override
  Widget build(BuildContext context) {
    print("RecommendedRooms build triggered ✅");

    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      builder: (context, state) {
        if (state is WorkspaceLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is WorkspaceError) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(color: Colors.red[600]),
            ),
          );
        } else if (state is WorkspaceLoaded) {
          final workspaces = state.topRatedWorkspaces;

          // خد أول N غرفة من كل ورك سبيس (هنا بدون limit)
          final allRoomsWithWorkspaceId = workspaces.expand((ws) {
            final rooms = ws.rooms ?? [];
            return rooms.map((room) => MapEntry(room, ws.id));
          }).toList();

          // لو حابة تحددي عدد معين من الغرف فقط مثلاً 5:
          // final allRooms = workspaces.expand((ws) => ws.rooms ?? []).take(5).toList();

          if (allRoomsWithWorkspaceId.isEmpty) {
            return const Center(
              child: Text('No recommended rooms found.'),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle('Top Rated Rooms!'),
              SizedBox(
                height: 280,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allRoomsWithWorkspaceId.length,
                    itemBuilder: (context, index) {
                      final entry = allRoomsWithWorkspaceId[index];
                      final room = entry.key;
                      final workspaceId = entry.value;

                      return RoomCardForHome(
                        room: room,
                        workspaceId: workspaceId, // 👈 مرر الـ id هنا
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink(); // في حال كانت الستيت مش من النوع اللي فوق
      },
    );
  }
}
