import 'package:intl/intl.dart';

class BookingUtils {
  static DateTime parseTime(String time) {
    final cleanedTime = time.replaceAll(RegExp(r'\\s+'), ' ').trim();

    try {
      return DateFormat('h:mm a').parse(cleanedTime);
    } catch (e) {
      try {
        return DateFormat('H:mm').parse(cleanedTime);
      } catch (e2) {
        return DateTime.now();
      }
    }
  }

  static List<String> generateTimeSlots(DateTime start, DateTime end) {
    final slots = <String>[];
    final format = DateFormat("h:mm a");
    DateTime current = DateTime(start.year, start.month, start.day, start.hour, 0);

    while (current.isBefore(end)) {
      slots.add(format.format(current));
      current = current.add(const Duration(minutes: 30));
    }

    return slots;
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}