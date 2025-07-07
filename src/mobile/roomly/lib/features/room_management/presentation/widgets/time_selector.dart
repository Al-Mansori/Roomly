import 'package:flutter/material.dart';

class TimeSelector extends StatelessWidget {
  final List<String> times;
  final String selectedTime;
  final ValueChanged<String>? onSelect;
  final bool isEnabled;

  const TimeSelector({
    required this.times,
    required this.selectedTime,
    required this.onSelect,
    required this.isEnabled,
  });


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: times.length,
        itemBuilder: (context, index) {
          final time = times[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              style: time == selectedTime
                  ? ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A3FB3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ) // 👈 قفلي هنا
                  : ElevatedButton.styleFrom(
                backgroundColor: isEnabled ? Colors.white : Colors.grey[200],
                foregroundColor: isEnabled ? Colors.black : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isEnabled ? Colors.grey : Colors.grey[300]!,
                  ),


          ),
              ),
          onPressed: isEnabled ? () => onSelect?.call(time) : null,
          child: Text(time),
          ),
          );
        },
      ),
    );
  }
}