import 'package:flutter/material.dart';

class BookingSummary extends StatelessWidget {
  final bool isPrivate;
  final int numberOfSeats;
  final int maxSeats;
  final double totalPrice;
  final double discountedPrice;
  final bool isValid;
  final String? errorMessage;
  final VoidCallback? onReviewPressed;
  final ValueChanged<int>? onSeatsChanged;

  const BookingSummary({
    required this.isPrivate,
    required this.numberOfSeats,
    required this.maxSeats,
    required this.totalPrice,
    required this.discountedPrice,
    required this.isValid,
    this.errorMessage,
    this.onReviewPressed,
    this.onSeatsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                errorMessage!,
                style: TextStyle(
                  color: Colors.red[300],
                  fontSize: 12,
                ),
              ),
            ),
          _buildSeatsSelector(),
          const SizedBox(height: 12),
          _buildPriceAndButton(),
        ],
      ),
    );
  }

  Widget _buildSeatsSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const Icon(Icons.event_seat, color: Colors.white, size: 18),
          const SizedBox(width: 4),
          Text(
            isPrivate ? "Private Room" : "Number of Seats:",
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          if (!isPrivate) ...[
            const SizedBox(width: 15),
            _buildControlButton(
              Icons.remove,
                  () => onSeatsChanged?.call(numberOfSeats - 1),
              enabled: numberOfSeats > 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '$numberOfSeats',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            _buildControlButton(
              Icons.add,
                  () => onSeatsChanged?.call(numberOfSeats + 1),
              enabled: numberOfSeats < maxSeats,
            ),
            if (maxSeats > 0)
              Text(
                '/ $maxSeats',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
          ] else ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "1",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceAndButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total ${totalPrice.toStringAsFixed(1)} EGP',
                style: TextStyle(
                  color: isValid ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (!isPrivate)
                Text(
                  '${discountedPrice.toStringAsFixed(1)} EGP/hour × $numberOfSeats seats',
                  style: TextStyle(
                    color: isValid ? Colors.white70 : Colors.grey,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              if (isPrivate)
                Text(
                  '${discountedPrice.toStringAsFixed(1)} EGP/hour',
                  style: TextStyle(
                    color: isValid ? Colors.white70 : Colors.grey,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: isValid ? onReviewPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isValid ? const Color(0xFF0A3FB3) : Colors.grey[700],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Review Booking',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed, {bool enabled = true}) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border.all(
          color: enabled ? Colors.white : Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        icon: Icon(icon, size: 14, color: enabled ? Colors.white : Colors.grey),
        onPressed: enabled ? onPressed : null,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        iconSize: 14,
      ),
    );
  }
}