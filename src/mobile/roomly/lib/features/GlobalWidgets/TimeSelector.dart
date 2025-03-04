import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeSelector extends StatefulWidget {
  final List<String> times;

  TimeSelector({required this.times});

  @override
  _TimeSelectorState createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  String? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widget.times.map((time) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedTime = time;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedTime == time
                    ? Color(0xFF0A3FB3)
                    : Color(0xFFD9D9D9),
                foregroundColor: _selectedTime == time ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
              ),
              child: Text(time),
            ),
          );
        }).toList(),
      ),
    );
  }
}