import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/room_management/data/data_sources/offer_remote_data_source.dart';
import 'package:roomly/features/room_management/data/data_sources/room_remote_data_source.dart';
import 'package:roomly/features/room_management/data/repositories/room_repository_impl.dart';
import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
import 'package:roomly/features/room_management/domain/usecases/get_room_details_usecase.dart';

class RoomCardWidget extends StatefulWidget {
  final String roomId;
  final String workspaceId;
  final VoidCallback onFavoriteToggle;
  final bool isFavorite;

  const RoomCardWidget({
    Key? key,
    required this.roomId,
    required this.workspaceId,
    required this.onFavoriteToggle,
    required this.isFavorite,
  }) : super(key: key);

  @override
  State<RoomCardWidget> createState() => _RoomCardWidgetState();
}

class _RoomCardWidgetState extends State<RoomCardWidget> {
  RoomEntity? _roomDetails;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchRoomDetails();
  }

  Future<void> _fetchRoomDetails() async {
    try {
      final getRoomDetailsUseCase = GetRoomDetailsUseCase(
        RoomRepositoryImpl(
          offerRemoteDataSource: OfferRemoteDataSourceImpl(dio: Dio()),
          remoteDataSource: RoomRemoteDataSourceImpl(dio: Dio()),
        ),
      );
      final room = await getRoomDetailsUseCase(widget.roomId);
      setState(() {
        _roomDetails = room;
        _error = room == null ? 'Failed to load room details' : null;
      });
    } catch (e) {
      setState(() => _error = 'An unexpected error occurred');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      return Center(child: Text('Error: $_error'));
    } else if (_roomDetails == null) {
      return const Center(child: Text('Room details not found.'));
    } else {
      final imageUrl = _roomDetails!.roomImages != null && _roomDetails!.roomImages!.isNotEmpty
          ? _roomDetails!.roomImages![0].imageUrl
          : null;

      return GestureDetector(
        onTap: () {
          context.push(
            '/room/${widget.roomId}',
            // extra: workspaceCubit,
            extra: {
              'workspaceId': widget.workspaceId,
            },
          );
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          elevation: 4.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[200],
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                          ),
                        )
                      : Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _roomDetails!.name ?? 'N/A',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _roomDetails!.description ?? 'No description available.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.people, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          // Use Flexible instead of Expanded for the Text widgets
                          Flexible(
                            child: Text(
                              '${_roomDetails!.capacity ?? 'N/A'} people',
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.attach_money, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${_roomDetails!.pricePerHour?.toStringAsFixed(2) ?? 'N/A'} / hour',
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: widget.isFavorite ? Colors.red : Colors.grey[400],
                    size: 28,
                  ),
                  onPressed: widget.onFavoriteToggle,
                  tooltip: widget.isFavorite ? 'Remove from favorites' : 'Add to favorites',
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

