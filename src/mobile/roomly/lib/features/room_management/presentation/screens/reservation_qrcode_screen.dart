// features/room_management/presentation/reservation_qrcode_screen.dart
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReservationQRCodeScreen extends StatelessWidget {
  const ReservationQRCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Reservation',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // QR Code
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                padding: const EdgeInsets.all(10),
                child: QrImageView(
                  data: 'https://example.com/reservation/123456',
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Reservation Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Name: John Doe',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Booking ID: #123456',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Date & Time: September 10, 2025 - 2:00 PM',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Workspace: Room A',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Duration: 3 Hours',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Action Buttons
            Row(
              children: [
                // Share Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Share functionality
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: Colors.blue,
                    ),
                    label: const Text(
                      'Share',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 15),

                // Save Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Save functionality
                    },
                    icon: const Icon(
                      Icons.download,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
