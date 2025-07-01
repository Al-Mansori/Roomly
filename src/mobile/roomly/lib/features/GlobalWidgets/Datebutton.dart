import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResponsiveContainer extends StatelessWidget {
  final dynamic roomEntity;
  final DateTime selectedDate;
  final String selectedCheckInTime;
  final String selectedCheckOutTime;
  final String userId;

  const ResponsiveContainer({
    super.key,
    required this.roomEntity,
    required this.selectedDate,
    required this.selectedCheckInTime,
    required this.selectedCheckOutTime,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Number of seats:',
                style: _textStyle(),
              ),
              const SizedBox(height: 4),
              Text(
                'Total 114.0 EGP',
                style: _textStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              backgroundColor: const Color(0xFF0A3FB3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              context.push(
                '/review-booking',
                extra: {
                  'room': roomEntity,
                  'selectedDate': selectedDate,
                  'checkInTime': selectedCheckInTime,
                  'checkOutTime': selectedCheckOutTime,
                  'userId': userId,
                },
              );
            },
            child: Text(
              'Review Booking',
              style: _textStyle(),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _textStyle({FontWeight fontWeight = FontWeight.normal}) {
    return TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontFamily: 'Roboto',
      fontWeight: fontWeight,
    );
  }
}