import 'package:flutter/material.dart';
import 'package:roomly/features/loyalty/domain/entities/loyalty_points_entity.dart';

class ExpirationWarning extends StatelessWidget {
  final LoyaltyPointsEntity loyaltyPoints;

  const ExpirationWarning({
    super.key,
    required this.loyaltyPoints,
  });

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    // Calculate expiration date (points expire after 2 months from lastUpdatedDate)
    final expirationDate = DateTime(
      loyaltyPoints.lastUpdatedDate.year,
      loyaltyPoints.lastUpdatedDate.month + 2,
      loyaltyPoints.lastUpdatedDate.day,
    );
    final daysUntilExpiration = expirationDate.difference(DateTime.now()).inDays;

    // If totalPoints is null or 0, return an empty SizedBox
    if (loyaltyPoints.totalPoints == null || loyaltyPoints.totalPoints == 0) {
      return const SizedBox.shrink();
    }

    // If points have already expired
    if (daysUntilExpiration < 0) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE57373),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.error,
              color: Color(0xFFD32F2F),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'The points have expired on ${_formatDate(expirationDate)}',
                style: TextStyle(
                  color: Colors.red[800],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // If points expire within 30 days, show warning
    if (daysUntilExpiration <= 30) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFFFB74D),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.warning,
              color: Color(0xFFFF9800),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'The points will expire on ${_formatDate(expirationDate)}',
                style: TextStyle(
                  color: Colors.orange[800],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // If points expire in more than 30 days, show info message
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF90CAF9),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info,
            color: Color(0xFF1976D2),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'The points will expire on ${_formatDate(expirationDate)}',
              style: TextStyle(
                color: Colors.blue[800],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

