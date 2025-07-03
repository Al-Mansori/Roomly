import 'package:flutter/material.dart';
import '../../domain/entities/booking_with_room.dart';

enum BookingCardType { ongoing, upcoming, pending, history }

class BookingCard extends StatelessWidget {
  final BookingWithRoom bookingWithRoom;
  final BookingCardType type;
  final VoidCallback? onCancel;
  final VoidCallback? onRebook;

  const BookingCard({
    Key? key,
    required this.bookingWithRoom,
    required this.type,
    this.onCancel,
    this.onRebook,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final room = bookingWithRoom.roomDetails;
    final booking = bookingWithRoom.reservation;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: room.imageUrl.isNotEmpty
                      ? Image.network(
                          room.imageUrl,
                          width: 90,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/360-workspace-kita-e2-open-office (1).jpg',
                              width: 90,
                              height: 70,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/images/360-workspace-kita-e2-open-office (1).jpg',
                          width: 90,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        room.description,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Amenities: ${booking.amenitiesCount}',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (type == BookingCardType.ongoing) ...[
              Text('Date: ${_formatDate(booking.reservationDate)}'),
              Text(
                  'Time: ${_formatTime(booking.startTime)} - ${_formatTime(booking.endTime)}'),
              Text('Total Cost: \$${booking.totalCost.toStringAsFixed(2)}'),
            ],
            if (type == BookingCardType.upcoming ||
                type == BookingCardType.pending) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: BorderSide(color: Colors.black.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Cancel Booking",
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ],
            if (type == BookingCardType.history) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${_formatDate(booking.startTime)} - ${_formatDate(booking.endTime)}'),
                      Text('\$${booking.totalCost.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(booking.status,
                          style: const TextStyle(color: Colors.blue)),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: onRebook,
                    icon:
                        const Icon(Icons.refresh, color: Colors.blue, size: 18),
                    label: const Text('Rebook',
                        style: TextStyle(color: Colors.blue)),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
