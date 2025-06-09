import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../GlobalWidgets/ReusableCarrasoul.dart';
import 'package:roomly/features/room_management/domain/entities/amenity_entity.dart';
import 'package:roomly/features/room_management/presentation/cubits/room_details_cubit.dart';
import 'package:roomly/features/room_management/presentation/cubits/room_details_state.dart';
import 'package:go_router/go_router.dart';

class RoomDetailsScreen extends StatefulWidget {
  final String roomId;

  const RoomDetailsScreen({Key? key, required this.roomId}) : super(key: key);

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RoomDetailsCubit>().getRoomDetails(widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RoomDetailsCubit, RoomDetailsState>(
        builder: (context, state) {
          if (state is RoomDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RoomDetailsLoaded) {
            final room = state.room;
            final images = state.images;

            print("This is the room from cubit ==> ${room.toString()}");
            
            // Extract image URLs from the images list
            final imageUrls = images.map((image) => image.imageUrl).whereType<String>().toList();
            
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Carousel with images
                  Stack(
                    children: [
                      ReusableCarousel(
                        images: imageUrls.isNotEmpty 
                            ? imageUrls 
                            : ['https://media.istockphoto.com/id/1337718884/photo/modern-office-at-home.jpg?s=612x612&w=0&k=20&c=kXlpCzVsqV360jaC9UkaXGhcGh8VLURkybD9NqBfQKE='],
                        height: 250,
                        autoPlay: true,
                      ),
                      // Back button
                      Positioned(
                        top: 40,
                        left: 10,
                        child: GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_back, color: Colors.black),
                          ),
                        ),
                      ),
                      // Favorite button
                      Positioned(
                        top: 40,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.favorite_border, color: Colors.black),
                        ),
                      ),
                      // Share button
                      Positioned(
                        top: 40,
                        right: 60,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.share, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  
                  // Room name and rating
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Name of workspace',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            const Text(
                              '4.92',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(116 reviews)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          room.name ?? 'Meeting Room',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Loyalty points section
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.card_giftcard, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Use Your Loyalty Point To Save Some money',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                  
                  // Voucher code section
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.receipt_outlined, color: Colors.grey),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter voucher code',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Open hours
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Open Hours',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.access_time, size: 16),
                            ),
                            const SizedBox(width: 8),
                            const Text('Today: 9:00 AM - 11:00 PM'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Amenities
                  if (room.amenities != null && room.amenities!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amenities (${room.amenities!.length})',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: _buildAmenityChips(room.amenities!),
                          ),
                        ],
                      ),
                    ),
                  
                  // Location
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade200,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQF3Q50EAiE9A_I_KEpe9RET3m8tMuXQLed7Q&s',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.location_on, size: 40, color: Colors.grey),
                                        Text('Map Location', style: TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '63 Syria, Mit Akaba, Agouza, Giza Governorate 12655',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '12 km away',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Add some bottom padding to ensure content is not hidden behind the bottom bar
                  const SizedBox(height: 100),
                ],
              ),
            );
          } else if (state is RoomDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RoomDetailsCubit>().getRoomDetails(widget.roomId);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Select a room to view details'));
          }
        },
      ),
      // Bottom bar with price and book button - positioned as a fixed bottom bar
      bottomNavigationBar: BlocBuilder<RoomDetailsCubit, RoomDetailsState>(
        builder: (context, state) {
          if (state is RoomDetailsLoaded) {
            final room = state.room;
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${room.pricePerHour?.toStringAsFixed(2) ?? '57.0'} EGP/Hour',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('EGP/Hour'),
                              Icon(Icons.keyboard_arrow_down, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to booking screen
                        context.push('/booking/${room.id}');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Select Date',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  List<Widget> _buildAmenityChips(List<AmenityEntity> amenities) {
    return amenities.map((amenity) {
      IconData iconData;
      switch (amenity.type?.toLowerCase()) {
        case 'wifi':
        case 'wi-fi':
        case 'internet':
          iconData = Icons.wifi;
          break;
        case 'parking':
        case 'car':
          iconData = Icons.local_parking;
          break;
        case 'tea':
        case 'coffee':
        case 'beverage':
        case 'drink':
          iconData = Icons.emoji_food_beverage;
          break;
        case 'projector':
        case 'screen':
          iconData = Icons.tv;
          break;
        case 'whiteboard':
        case 'board':
          iconData = Icons.dashboard;
          break;
        case 'air conditioning':
        case 'ac':
        case 'cooling':
          iconData = Icons.ac_unit;
          break;
        case 'heating':
          iconData = Icons.whatshot;
          break;
        case 'printer':
          iconData = Icons.print;
          break;
        case 'phone':
        case 'telephone':
          iconData = Icons.phone;
          break;
        case 'chairs':
          iconData = Icons.chair;
          break;
        case 'desk':
          iconData = Icons.table_bar;
          break;
        case 'security':
        case 'safe':
          iconData = Icons.security;
          break;
        default:
          iconData = Icons.check_circle;
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData, size: 16, color: Colors.grey.shade700),
            const SizedBox(width: 4),
            Text(
              amenity.name ?? 'Amenity',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

