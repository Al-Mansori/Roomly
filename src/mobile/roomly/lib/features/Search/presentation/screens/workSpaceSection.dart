import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WorkspaceResultCard extends StatelessWidget {
  final String imageUrl;
  final String distance;
  final String workspaceName;
  final String workspaceId;

  const WorkspaceResultCard({
    super.key,
    required this.imageUrl,
    required this.distance,
    required this.workspaceName,
    required this.workspaceId,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    void _navigateToWorkspace() {
      context.push('/workspace/$workspaceId');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _navigateToWorkspace,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              width: screenWidth * 0.4,
              height: screenWidth * 0.32,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8), // Spacing
        Text(
          '$distance KM away',
          style: TextStyle(
            color: Color(0xFF808080),
            fontSize: screenWidth * 0.025,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
        Text(
          workspaceName,
          style: TextStyle(
            color: Colors.black,
            fontSize: screenWidth * 0.025,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}
