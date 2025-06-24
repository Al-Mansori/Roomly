import 'package:flutter/material.dart';
import 'package:roomly/features/request/domain/entities/request.dart';

class RequestDetailScreen extends StatelessWidget {
  final Request request;

  const RequestDetailScreen({Key? key, required this.request}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Request Details',
          style: TextStyle(color: Colors.white), // White text for app bar title
        ),
        backgroundColor: Colors.blue[800], // Darker blue for app bar
        iconTheme: const IconThemeData(color: Colors.white), // White icons
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[800]!, // Darker blue at the top
              Colors.blue[400]!, // Lighter blue at the bottom
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            color: Colors.white.withOpacity(0.9), // Slightly transparent white card
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Request ID:', request.id),
                  _buildDetailRow('Type:', request.type),
                  _buildDetailRow('Request Date:', request.requestDate),
                  _buildDetailRow('Response Date:', request.responseDate),
                  _buildDetailRow('Status:', request.status),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Details:',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    request.details,
                    style: const TextStyle(fontSize: 16.0, color: Colors.black87),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Response:',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    request.requestResponse,
                    style: const TextStyle(fontSize: 16.0, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16.0, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}


