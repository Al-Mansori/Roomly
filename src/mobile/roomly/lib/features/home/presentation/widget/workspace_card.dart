import 'package:flutter/material.dart';
import '../../data/models/workspace_model.dart';

class WorkspaceCard extends StatelessWidget {
  final Workspace workspace;

  const WorkspaceCard({required this.workspace, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.75; // 75% of screen width
    final cardHeight = screenWidth * 0.6; // 60% of screen width
    final imageHeight = cardHeight * 0.5; // Image takes 50% of card height

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE SECTION
          Container(
            height: imageHeight,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              image: DecorationImage(
                image: AssetImage(workspace.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // TEXT CONTENT (SCROLLABLE)
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE & LOCATION
                  Text(
                    workspace.title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    workspace.location,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),

                  // DETAILS
                  Text(
                    workspace.details,
                    style: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                  const SizedBox(height: 6),

                  // RATING & PRICE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // STAR RATING
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          Text(
                            " ${workspace.rating} (${workspace.reviews} reviews)",
                            style: TextStyle(fontSize: screenWidth * 0.035),
                          ),
                        ],
                      ),

                      // PRICE
                      Text(
                        workspace.price,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // SEE MORE BUTTON
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "See more →",
                        style: TextStyle(fontSize: screenWidth * 0.035),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}