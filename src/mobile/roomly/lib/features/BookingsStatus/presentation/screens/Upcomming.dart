import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpcomingReservations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ReservationCard(
          title: 'Meeting Room (2 people)',
          description: '2 rooms - business, gaming, studying workspace can be customized',
          distance: '12.5 km away',
        ),
        ReservationCard(
          title: 'Meeting Room (2 people)',
          description: '2 rooms - business, gaming, studying workspace can be customized',
          distance: '12.5 km away',
        ),
      ],
    );
  }
}

class ReservationCard extends StatelessWidget {
  final String title;
  final String description;
  final String distance;

  ReservationCard({
    required this.title,
    required this.description,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 8),
            Text(distance, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}