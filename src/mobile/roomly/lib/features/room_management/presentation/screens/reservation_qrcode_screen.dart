import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ReservationQRCodeScreen extends StatelessWidget {
  final Map<String, dynamic> reservationData;
  final ScreenshotController _screenshotController = ScreenshotController();

  ReservationQRCodeScreen({
    super.key,
    required this.reservationData,
  });

  @override
  Widget build(BuildContext context) {
    // Convert data to JSON string for QR Code
    final qrData = reservationData.toString();
    final qrKey = GlobalKey();

    // Format date
    final formattedDate = DateFormat('MMMM d, y').format(
      DateTime.parse(reservationData['Date'] ?? DateTime.now().toString()),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          reservationData['RoomName'] ?? 'Reservation',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // QR Code Section
                Column(
                  children: [
                    const Text(
                      'Scan this QR Code to access your reservation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Screenshot(
                          controller: _screenshotController,
                          child: RepaintBoundary(
                            key: qrKey,
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(20),
                              child: QrImageView(
                                data: qrData,
                                version: QrVersions.auto,
                                size: 200.0,
                                embeddedImage: const AssetImage('assets/logo.png'),
                                embeddedImageStyle: const QrEmbeddedImageStyle(
                                  size: Size(40, 40),
                                ),
                              ),
                            ),
                          ),
                        ),

                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Access Code: ${reservationData['AccessCode'] ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Reservation Details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDetailRow(
                          'Workspace:', reservationData['WorkspaceName']),
                      _buildDetailRow(
                          'Room Type:', reservationData['RoomType']),
                      _buildDetailRow('Date:', formattedDate),
                      _buildDetailRow(
                          'Payment Method:', reservationData['paymentMethod']),
                      _buildDetailRow('Reservation ID:',
                          reservationData['ReservationId']
                              ?.toString()
                              .substring(0, 8) ?? ''),
                      _buildDetailRow('Status:', reservationData['Status'],
                          isStatus: true),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Action Buttons
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      // Share Button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _shareReservation(context),
                          icon: const Icon(Icons.share, color: Colors.blue),
                          label: const Text(
                            'Share',
                            style: TextStyle(color: Colors.blue),
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
                          onPressed: () => _saveQRCode(context),
                          icon: const Icon(Icons.download, color: Colors.white),
                          label: const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                fontSize: 14,
                color: isStatus
                    ? _getStatusColor(value ?? '')
                    : Colors.black,
                fontWeight: isStatus ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      case 'PENDING':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _shareReservation(BuildContext context) async {
    try {
      // Capture the QR code image with higher quality
      final image = await _screenshotController.capture(pixelRatio: 3.0);
      if (image == null) throw Exception("Failed to capture QR");

      // Format the reservation details
      final formattedDate = DateFormat('MMMM d, y').format(
        DateTime.parse(reservationData['Date'] ?? DateTime.now().toString()),
      );

      final details = '''
Room Reservation Details:
-----------------------------
Workspace: ${reservationData['WorkspaceName'] ?? 'N/A'}
Room Type: ${reservationData['RoomType'] ?? 'N/A'}
Date: $formattedDate
Access Code: ${reservationData['AccessCode'] ?? 'N/A'}
Reservation ID: ${reservationData['ReservationId']?.toString().substring(0, 8) ?? 'N/A'}
Status: ${reservationData['Status'] ?? 'N/A'}
-----------------------------
Please present this QR code when you arrive.
''';

      // Save image to a temporary file
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/Roomly_Reservation_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(image);

      // Share both text and image using share_plus with XFile
      await Share.shareXFiles(
        [XFile(file.path)],
        text: details,
        subject: 'My Room Reservation - ${reservationData['RoomName'] ?? 'Room'}',
      );

      // Clean up the temporary file
      Future.delayed(const Duration(seconds: 10), () async {
        try {
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          debugPrint('Error deleting temp file: $e');
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sharing: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
  static const platform = MethodChannel('com.example.roomly/save_image');


  void _saveQRCode(BuildContext context) async {
    try {
      final image = await _screenshotController.capture(pixelRatio: 3.0);
      if (image == null) throw Exception("Failed to capture image");

      final result = await platform.invokeMethod('saveImageToGallery', image);
      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('QR Code saved successfully!')),
        );
      } else {
        throw Exception("Failed to save image");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving QR Code: ${e.toString()}')),
      );
    }
  }


}