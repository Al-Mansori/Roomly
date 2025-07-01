import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/workspace.dart';

class RoomCardForTypes extends StatefulWidget {
  final Room room;
  final String workspaceId;
  final Function(Room)? onTap;
  final bool showSeeMore;
  final bool isCompactMode;

  const RoomCardForTypes({
    required this.room,
    required this.workspaceId,
    this.onTap,
    this.showSeeMore = true,
    this.isCompactMode = false, // وضع مدمج للعروض المختلفة
    Key? key,
  }) : super(key: key);

  @override
  State<RoomCardForTypes> createState() => _RoomCardForTypesState();
}

class _RoomCardForTypesState extends State<RoomCardForTypes> {
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
    final cardWidth = widget.isCompactMode ? screenWidth * 0.9 : screenWidth * 0.75;
    final imageHeight = widget.isCompactMode ? cardWidth * 0.4 : cardWidth * 0.55;

    return GestureDetector(
      onTap: () => _navigateToRoomDetails(context),
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(bottom: 16),
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            _buildImageSection(theme, imageHeight),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Status
                  _buildTitleAndStatus(theme),

                  const SizedBox(height: 8),

                  // Description
                  _buildDescription(theme),

                  const SizedBox(height: 12),

                  // Price and Actions
                  _buildPriceAndActions(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(ThemeData theme, double imageHeight) {
    return SizedBox(
      height: imageHeight,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: widget.room.images.isEmpty
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
          itemCount: widget.room.images.length,
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl: widget.room.images[index],
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
    );
  }

  Widget _buildTitleAndStatus(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.room.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (widget.room.status != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.room.status!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Text(
      widget.room.description ?? 'No description available',
      style: theme.textTheme.bodySmall,
      maxLines: widget.isCompactMode ? 1 : 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPriceAndActions(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Rating and Price
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            const SizedBox(width: 4),
            Text(
              widget.room.pricePerHour.toStringAsFixed(1),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(width: 8),
            Text(
              '${widget.room.pricePerHour.toStringAsFixed(0)} EGP/h',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),

        // See More Button
        if (widget.showSeeMore)
          TextButton(
            onPressed: () => _navigateToRoomDetails(context),
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
            ),
          ),
      ],
    );
  }

  void _navigateToRoomDetails(BuildContext context) {
    final workspaceId = widget.workspaceId;
    if (workspaceId != null) {
      GoRouter.of(context).push(
        '/room/${widget.room.id}',
        extra: {'workspaceId': workspaceId},
      );
    } else {
      debugPrint("❌ workspaceId is null, can't navigate to room details.");
    }
  }
}