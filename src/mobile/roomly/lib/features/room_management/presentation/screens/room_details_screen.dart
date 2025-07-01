import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomly/features/workspace/data/models/workspace_model.dart';
import 'package:roomly/features/workspace/presentation/cubits/workspace_details_cubit.dart';
import 'package:roomly/features/workspace/presentation/screens/location_map_widget.dart';
import '../../../GlobalWidgets/ReusableCarrasoul.dart';
import 'package:roomly/features/room_management/domain/entities/amenity_entity.dart';
import 'package:roomly/features/room_management/domain/entities/offer_entity.dart';
import 'package:roomly/features/room_management/presentation/cubits/room_details_cubit.dart';
import 'package:roomly/features/room_management/presentation/cubits/room_details_state.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/data/data_sources/secure_storage.dart';

class RoomDetailsScreen extends StatefulWidget {
  final String roomId;
  final String? workspaceId;

  const RoomDetailsScreen({
    Key? key,
    required this.roomId,
    this.workspaceId
  }) : super(key: key);

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}
class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  bool _isFavorite = false;
  String? userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserId();
    context.read<RoomDetailsCubit>().getRoomDetails(widget.roomId);

    // If workspaceId is provided, fetch workspace details
  }
  Future<void> loadUserId() async {
    final fetchedUserId = await SecureStorage.getId();
    print("From Details UserId = ${fetchedUserId} ");
    setState(() {
      userId = fetchedUserId;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomDetailsCubit, RoomDetailsState>(
      listener: (context, state) {
        if (state is RoomDetailsLoaded) {
          setState(() {
            _isFavorite = state.isFavorite;
          });
        }
      },
      child: Scaffold(
        body: BlocBuilder<RoomDetailsCubit, RoomDetailsState>(
        builder: (context, state) {
          if (state is RoomDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RoomDetailsLoaded) {
            final room = state.room;
            final images = state.images;
            final offers = state.offers;

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
                        child: GestureDetector(
                          onTap: () {
                            context.read<RoomDetailsCubit>().toggleFavoriteStatus(widget.roomId, _isFavorite);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: _isFavorite ? Colors.red : Colors.black,
                            ),
                          ),
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
                              'Room Name',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.event_seat, color: Colors.green, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${room.availableCount ?? 0} Seats Available',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.green,
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
                  
                  // Offers section - only show if there are offers
                  if (offers.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.local_offer, color: Colors.green, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Special Offers Available',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...offers.map((offer) => _buildOfferCard(offer, room.pricePerHour ?? 0.0)).toList(),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
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
                        // Location Map Widget with Debug Logging
                              BlocBuilder<WorkspaceDetailsCubit, WorkspaceDetailsState>(
                                builder: (context, state) {
                                  if (state is WorkspaceDetailsLoaded) {
                                    final workspace = state.workspace;
                                    
                                    // Debug logging for workspace details screen
                                    print('WorkspaceDetailsScreen - Workspace type: ${workspace.runtimeType}');
                                    print('WorkspaceDetailsScreen - Workspace address: ${workspace.address}');
                                    
                                    // Check if workspace is a WorkspaceModel with location
                                    if (workspace is WorkspaceModel) {
                                      print('WorkspaceDetailsScreen - WorkspaceModel location: ${workspace.location}');
                                      if (workspace.location != null) {
                                        print('WorkspaceDetailsScreen - Location latitude: ${workspace.location!.latitude}');
                                        print('WorkspaceDetailsScreen - Location longitude: ${workspace.location!.longitude}');
                                        print('WorkspaceDetailsScreen - Location id: ${workspace.location!.id}');
                                        print('WorkspaceDetailsScreen - Location city: ${workspace.location!.city}');
                                        print('WorkspaceDetailsScreen - Location country: ${workspace.location!.country}');
                                        
                                        return LocationMapWidget(
                                          latitude: workspace.location!.latitude,
                                          longitude: workspace.location!.longitude,
                                          address: workspace.address,
                                          height: 200,
                                          borderRadius: 12,
                                        );
                                      } else {
                                        print('WorkspaceDetailsScreen - Location is null');
                                        // Fallback for workspace without location data
                                        return LocationMapWidget(
                                          latitude: null,
                                          longitude: null,
                                          address: workspace.address,
                                          height: 200,
                                          borderRadius: 12,
                                        );
                                      }
                                    } else {
                                      print('WorkspaceDetailsScreen - Workspace is not WorkspaceModel, type: ${workspace.runtimeType}');
                                      // Fallback for non-WorkspaceModel entities
                                      return LocationMapWidget(
                                        latitude: null,
                                        longitude: null,
                                        address: workspace.address,
                                        height: 200,
                                        borderRadius: 12,
                                      );
                                    }
                                  }
                                  // Loading state
                                  return Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
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
            final offers = state.offers;
            final originalPrice = room.pricePerHour ?? 57.0;
            final hasActiveOffer = offers.any((offer) => offer.status.toLowerCase() == 'active');
            final activeOffer = hasActiveOffer ? offers.firstWhere((offer) => offer.status.toLowerCase() == 'active') : null;
            final discountedPrice = activeOffer != null 
                ? originalPrice * (1 - activeOffer.discountPercentage / 100)
                : originalPrice;
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
                child: Flexible(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (hasActiveOffer) ...[
                            // Original price with strikethrough
                            Text(
                              '${originalPrice.toStringAsFixed(2)} EGP/Hour',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.red,
                                decorationThickness: 2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            // Discounted price in green
                            Text(
                              '${discountedPrice.toStringAsFixed(2)} EGP/Hour',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ] else
                            Text(
                              '${originalPrice.toStringAsFixed(2)} EGP/Hour',
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
                        onPressed: (room.availableCount ?? 0) > 0
                            ? () {
                          print('Navigating to date screen for room: ${room.id}');
                          context.push('/select-data', extra: {
                            'room': room,
                            'discountedPrice': discountedPrice,
                            'workspaceId': widget.workspaceId, // تأكد أن room تحتوي على workspaceId
                          });
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (room.availableCount ?? 0) > 0
                              ? Colors.blue
                              : Colors.grey, // Grey when disabled
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            (room.availableCount ?? 0) > 0
                                ? 'Select Date'
                                : 'No Seats Available',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
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

  Widget _buildOfferCard(OfferEntity offer, double originalPrice) {
    final discountedPrice = originalPrice * (1 - offer.discountPercentage / 100);
    final isActive = offer.status.toLowerCase() == 'active';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? Colors.green : Colors.grey.shade300,
          width: isActive ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  offer.offerTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  offer.status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${offer.discountPercentage.toStringAsFixed(0)}% OFF',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Price after discount: ',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                '${discountedPrice.toStringAsFixed(2)} EGP/Hour',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                'Valid: ${offer.validFrom} - ${offer.validTo}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}