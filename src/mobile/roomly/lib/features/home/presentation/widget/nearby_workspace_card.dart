import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/home/presentation/widget/workspace_card.dart';

import '../../../workspace/presentation/screens/workspace_details_screen.dart';

class NearbyWorkspaceCard extends StatelessWidget {
  final Map<String, dynamic> workspaceData;
  final List<String> imageUrls;
  final VoidCallback? onTap;

  const NearbyWorkspaceCard({
    super.key,
    required this.workspaceData,
    required this.imageUrls,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return WorkspaceCard(
      workspaceId: workspaceData['id'].toString(), // تأكد من تحويله لـ String
      title: workspaceData['name'] ?? 'Workspace',
      distance: _formatDistance(workspaceData['distance_km']),
      rating: _formatRating(workspaceData['rating']),
      imageUrls: imageUrls,
      type: workspaceData['type'],
      city: workspaceData['city'],
      onTap: onTap ?? () {
        debugPrint('Attempting to navigate to workspace: ${workspaceData['id']}');

        // الطريقة الأولى: استخدام GoRouter
        try {
          GoRouter.of(context).push('/workspace/${workspaceData['id']}');
        } catch (e) {
          debugPrint('GoRouter navigation error: $e');

          // الطريقة البديلة: استخدام Navigator مباشرة
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkspaceDetailsScreen(workspaceId: workspaceData['id'].toString()),
            ),
          );
        }
      },
    );
  }

  String _formatDistance(dynamic distance) {
    if (distance == null) return '0 km';
    if (distance is num) return '${distance.toStringAsFixed(1)} km';
    return distance.toString();
  }

  String _formatRating(dynamic rating) {
    if (rating == null) return '0.0';
    if (rating is num) return rating.toStringAsFixed(1);
    return rating.toString();
  }
}