// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:roomly/features/room_management/domain/entities/room_entity.dart';

// class RoomCardWidget extends StatelessWidget {
//   final RoomEntity room;

//   const RoomCardWidget({Key? key, required this.room}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Navigate to RoomDetailsScreen when a room card is tapped
//         context.go('/room/${room.id}');
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
//                   child: Image.network(
//                     room.roomImages != null && room.roomImages!.isNotEmpty
//                         ? room.roomImages!.first.imageUrl
//                         : 'https://media.istockphoto.com/id/1337718884/photo/modern-office-at-home.jpg?s=612x612&w=0&k=20&c=kXlpCzVsqV360jaC9UkaXGhcGh8VLURkybD9NqBfQKE=',
//                     height: 150,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         height: 150,
//                         color: Colors.grey.shade200,
//                         child: const Center(
//                           child: Icon(
//                             Icons.image,
//                             size: 50,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 // Favorite button on image
//                 Positioned(
//                   right: 8,
//                   bottom: 8,
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                     ),
//                     child: IconButton(
//                       icon: const Icon(Icons.favorite_border,
//                           size: 18, color: Colors.grey),
//                       onPressed: () {
//                         // Favorite action
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             // Details
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           room.name ?? 'N/A',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           '${room.capacity ?? 'N/A'} Seats',
//                           style: TextStyle(
//                             color: Colors.grey.shade600,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Price and Book now button
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         '${room.pricePerHour?.toStringAsFixed(2) ?? 'N/A'} /Hour',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: Colors.orange,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       ElevatedButton(
//                         onPressed: () {
//                           // Navigate to booking screen
//                           context.push('/booking/${room.id}');
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         ),
//                         child: const Text(
//                           'Book Now',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// v2 ------------------------------------------------------------------------------------


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/room_management/domain/entities/room_entity.dart';

class RoomCardWidget extends StatelessWidget {
  final RoomEntity room;

  const RoomCardWidget({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to RoomDetailsScreen when a room card is tapped
        context.go('/room/${room.id}');
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
                        : 'https://media.istockphoto.com/id/1337718884/photo/modern-office-at-home.jpg?s=612x612&w=0&k=20&c=kXlpCzVsqV360jaC9UkaXGhcGh8VLURkybD9NqBfQKE=',
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
                          // Navigate to booking screen
                          context.push('/booking/${room.id}');
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

