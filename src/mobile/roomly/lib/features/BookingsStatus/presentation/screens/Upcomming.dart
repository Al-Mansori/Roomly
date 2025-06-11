import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpcomingReservations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
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
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(description),
            SizedBox(height: 8),
            Text(distance, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}