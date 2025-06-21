import 'package:flutter/material.dart';
import 'package:roomly/features/home/presentation/widget/section_title.dart';
import 'package:roomly/features/home/presentation/widget/workspace_card.dart';

import '../../data/models/workspace_model.dart';

class RecommendedWorkspaces extends StatelessWidget {
  const RecommendedWorkspaces({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaces = [
      Workspace(
          imagePath: "assets/images/Wo Space 3.png",
          title: "Meeting Room",
          location: "5.3 KM away",
          details: "2 rooms - business, gaming, studying workspace\ncan be customized",
          rating: 4.92,
          reviews: 116,
          price: "75 EGP/h"
      ),
      Workspace(
          imagePath: "assets/images/images (1).jpeg",
          title: "Private Office",
          location: "3.1 KM away",
          details: "Modern workspace with high-speed WiFi & custom seating",
          rating: 4.8,
          reviews: 98,
          price: "120 EGP/h"
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Recommended for you!'),
        SizedBox(
          height: 280,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: workspaces.length,
              itemBuilder: (context, index) {
                return WorkspaceCard(workspace: workspaces[index]);
              },
            ),
          ),
        ),
      ],
    );
  }
}