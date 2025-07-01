import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/workspace.dart';
class RoomCardForHome extends StatefulWidget {
  final Room room;
  final String workspaceId; // ✅ ضيفي دي
  final Function(Room)? onTap;
  final bool showSeeMore;

  const RoomCardForHome({
    required this.room,
    required this.workspaceId, // ✅ ضيفي دي كمان
    this.onTap,
    this.showSeeMore = true,
    Key? key,
  }) : super(key: key);


  @override
  State<RoomCardForHome> createState() => _RoomCardForHomeState();
}

class _RoomCardForHomeState extends State<RoomCardForHome> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.75;
    final cardHeight = screenWidth * 0.6;
    final imageHeight = cardHeight * 0.5;
    final images = widget.room.images;

    return GestureDetector(
      onTap: () {
        final workspaceId = widget.workspaceId;
        if (workspaceId != null) {
          GoRouter.of(context).push(
            '/room/${widget.room.id}',
            extra: {
              'workspaceId': workspaceId,
            },
          );
        } else {
          debugPrint("❌ workspaceId is null, can't navigate to room details.");
        }
      },
      child: SizedBox( // Use SizedBox instead of Container for better constraint control
        width: cardWidth,
        height: cardHeight,
        child: Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Carousel
              SizedBox(
                height: imageHeight,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: images.isEmpty
                      ? Container(
                    color: theme.colorScheme.surfaceVariant,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 40,
                      ),
                    ),
                  )
                      : PageView.builder(
                    controller: _controller,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        key: ValueKey(images[index]),
                        imageUrl: images[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: theme.colorScheme.surfaceVariant,
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: theme.colorScheme.errorContainer,
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              color: theme.colorScheme.onErrorContainer,
                              size: 40,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Content - Use Expanded to take remaining space
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Room name
                      Text(
                        widget.room.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Room status
                      if (widget.room.status != null)
                        Text(
                          widget.room.status!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                      const SizedBox(height: 8),

                      // Description - Use Flexible to allow text to shrink if needed
                      Flexible(
                        child: Text(
                          widget.room.description ?? 'No description available',
                          style: theme.textTheme.bodySmall,
                          maxLines: 2, // Reduced from 3 to 2 to prevent overflow
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const Spacer(), // Pushes the price and rating to the bottom

                      // Price and rating
// In _RoomCardForHomeState's build method, replace the price section with:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 20),
                                Flexible(
                                  child: Text(
                                    " ${widget.room.pricePerHour.toStringAsFixed(1)}",
                                    style: theme.textTheme.bodySmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '${widget.room.pricePerHour.toStringAsFixed(0)} EGP/h',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (widget.showSeeMore) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end, // محاذاة لليمين
                          children: [
                            Flexible( // إضافة Flexible لمنع الـ overflow
                              child: TextButton(
                                onPressed: () {
                                  final workspaceId = widget.workspaceId;
                                  if (workspaceId != null) {
                                    GoRouter.of(context).push(
                                      '/room/${widget.room.id}',
                                      extra: {'workspaceId': workspaceId},
                                    );
                                  } else {
                                    debugPrint("❌ workspaceId is null from See more");
                                  }
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  "See more →",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                  overflow: TextOverflow.ellipsis, // إضافة هذه السطر
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}