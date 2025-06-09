import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../GlobalWidgets/DateBox.dart';
import '../../../GlobalWidgets/Datebutton.dart';
import '../../../GlobalWidgets/TimeSelector.dart';
import '../../../GlobalWidgets/style.dart';

class SelectDataScreen extends StatefulWidget {
  @override
  _SelectDataScreenState createState() => _SelectDataScreenState();
}

class _SelectDataScreenState extends State<SelectDataScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Handle back button press
          },
          icon: const Icon(
            FontAwesomeIcons.arrowLeft,
            size: 16,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Select Date',
          style: pageTitleStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Expanded(
                    child: DateBox(date: '8 May 2024'),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: DateBox(date: '8 May 2024'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [globalShadow],
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'CheckIn',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TimeSelector(times: ['9:30 AM', '10:00 AM', '10:30 AM', '11:00 AM']),
              const SizedBox(height: 16),
              const Text(
                'Checkout',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TimeSelector(times: ['10:30 AM', '11:00 AM', '11:30 AM', '12:30 PM']),
              const SizedBox(height: 16),
              ResponsiveContainer(),             ],
          ),
        ),
      ),
    );
  }
}