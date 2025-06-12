import 'package:flutter/material.dart';
import 'package:roomly/features/loyalty/domain/entities/loyalty_points_entity.dart';

class WorkspaceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String details;
  final String imagePath;
  final int pointsCost;
  final LoyaltyPointsEntity loyaltyPoints;
  final bool isActionLoading;
  final Function(int) onRedeem;

  const WorkspaceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.details,
    required this.imagePath,
    required this.pointsCost,
    required this.loyaltyPoints,
    required this.isActionLoading,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    final int totalPoints = loyaltyPoints.totalPoints ?? 0;
    final canRedeem = totalPoints >= pointsCost;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[200],
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
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
          ),
          // Content Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (details.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          details,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: canRedeem && !isActionLoading
                      ? () => onRedeem(pointsCost)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canRedeem ? const Color(0xFF6B9EFF) : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    '$pointsCost Point',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

