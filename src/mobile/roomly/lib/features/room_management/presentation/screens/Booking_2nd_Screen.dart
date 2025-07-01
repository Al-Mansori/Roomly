import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectDataScreen extends StatefulWidget {
  final dynamic room;
  final double discountedPrice;
  final String workspaceId;

  const SelectDataScreen({
    super.key,
    required this.room,
    required this.discountedPrice,
    required this.workspaceId
  });

  @override
  _SelectDataScreenState createState() => _SelectDataScreenState();
}

class _SelectDataScreenState extends State<SelectDataScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  String _checkInTime = '9:30 AM';
  String _checkOutTime = '10:30 AM';

  int _numberOfSeats = 2;
  bool _isButtonVisible = true;
  bool _isDailyBooking = false;
  final ScrollController _scrollController = ScrollController();

  bool _isTimeValid = true;
  String _timeValidationMessage = '';

  final List<String> _checkInTimes = ['9:30 AM', '10:00 AM', '10:30 AM', '11:00 AM'];
  final List<String> _checkOutTimes = ['10:30 AM', '11:00 AM', '11:30 AM', '12:30 PM'];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _validateTimes();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _validateTimes() {
    final checkIn = _parseTime(_checkInTime);
    final checkOut = _parseTime(_checkOutTime);
    final now = DateTime.now();
    final isToday = isSameDay(_selectedDate, now);

    if (isToday && checkIn.isBefore(now)) {
      setState(() {
        _isTimeValid = false;
        _timeValidationMessage = 'Cannot select past times for today';
      });
      return;
    }

    if (checkOut.isBefore(checkIn)) {
      setState(() {
        _isTimeValid = false;
        _timeValidationMessage = 'Check-out must be after check-in';
      });
    } else if (checkOut == checkIn) {
      setState(() {
        _isTimeValid = false;
        _timeValidationMessage = 'Check-out cannot be same as check-in';
      });
    } else if (checkOut.difference(checkIn).inHours < 1) {
      setState(() {
        _isTimeValid = false;
        _timeValidationMessage = 'Minimum booking duration is 1 hour';
      });
    } else {
      setState(() {
        _isTimeValid = true;
        _timeValidationMessage = '';
      });
    }
  }

  void _handleCheckInChange(String time) {
    setState(() => _checkInTime = time);
    _validateTimes();
  }

  void _handleCheckOutChange(String time) {
    setState(() => _checkOutTime = time);
    _validateTimes();
  }

  DateTime _parseTime(String time) {
    try {
      final cleanedTime = time.replaceAll(RegExp(r'\s+'), ' ').trim();
      final format = DateFormat('h:mm a');
      return format.parse(cleanedTime);
    } catch (e) {
      print('Error parsing time: $time, error: $e');
      return DateTime.now();
    }
  }

  double getTotalPrice() {
    try {
      final isPrivate = widget.room.type?.toUpperCase() == 'PRIVATE';
      final checkIn = _parseTime(_checkInTime);
      final checkOut = _parseTime(_checkOutTime);

      if (checkOut.isBefore(checkIn)) {
        return 0.0;
      }

      final hours = checkOut.difference(checkIn).inHours.toDouble();
      return isPrivate
          ? widget.discountedPrice * hours
          : widget.discountedPrice * hours * _numberOfSeats;
    } catch (e) {
      print('Error calculating total price: $e');
      return 0.0;
    }
  }

  void _handleScroll() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isButtonVisible) {
        setState(() => _isButtonVisible = false);
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isButtonVisible) {
        setState(() => _isButtonVisible = true);
      }
    }
  }

  void _toggleDailyBooking(bool? value) {
    if (value != null) {
      setState(() {
        _isDailyBooking = value;
        if (_isDailyBooking) {
          _checkInTime = _checkInTimes.first;
          _checkOutTime = _checkOutTimes.last;
          _validateTimes();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(FontAwesomeIcons.arrowLeft, size: 16, color: Colors.black),
        ),
        title: const Text('Select Date and Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _isDailyBooking,
                      onChanged: _toggleDailyBooking,
                      activeColor: Color(0xFF0A3FB3),
                    ),
                    Text('Daily Booking'),
                    SizedBox(width: 16),
                    Radio<bool>(
                      value: false,
                      groupValue: _isDailyBooking,
                      onChanged: _toggleDailyBooking,
                      activeColor: Color(0xFF0A3FB3),
                    ),
                    Text('Custom Time'),
                  ],
                ),
                SizedBox(height: 16),

                Row(
                  children: [
                    Text(
                      DateFormat('d MMMM y').format(_selectedDate),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      DateFormat('MMMM y').format(_focusedDay),
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 4)],
                  ),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDate = selectedDay;
                        _focusedDay = focusedDay;
                        _validateTimes();
                      });
                    },
                    enabledDayPredicate: (day) {
                      return !day.isBefore(DateTime.now().subtract(Duration(days: 1)));
                    },
                    calendarFormat: _calendarFormat,
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
                      weekendStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Checkin', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildTimeSelector(
                  times: _checkInTimes,
                  selectedTime: _checkInTime,
                  onSelect: _isDailyBooking ? null : _handleCheckInChange,
                  isEnabled: !_isDailyBooking,
                ),
                const SizedBox(height: 8),
                if (!_isTimeValid && _timeValidationMessage.contains('check-in'))
                  Text(
                    _timeValidationMessage,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),

                const SizedBox(height: 24),
                const Text('Checkout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildTimeSelector(
                  times: _checkOutTimes,
                  selectedTime: _checkOutTime,
                  onSelect: _isDailyBooking ? null : _handleCheckOutChange,
                  isEnabled: !_isDailyBooking,
                ),
                const SizedBox(height: 8),
                if (!_isTimeValid && _timeValidationMessage.contains('check-out'))
                  Text(
                    _timeValidationMessage,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),

                const SizedBox(height: 100),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            bottom: MediaQuery.of(context).viewInsets.bottom > 0
                ? -100
                : (_isButtonVisible ? 20 : -100),
            left: 20,
            right: 20,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isButtonVisible && MediaQuery.of(context).viewInsets.bottom == 0 ? 1.0 : 0.0,
              child: _buildReviewButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector({
    required List<String> times,
    required String selectedTime,
    required ValueChanged<String>? onSelect,
    required bool isEnabled,
  }) {
    final now = DateTime.now();
    final isToday = isSameDay(_selectedDate, now);

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: times.length,
        itemBuilder: (context, index) {
          final time = times[index];
          final parsedTime = _parseTime(time);
          final isTimePassed = isToday && parsedTime.isBefore(now);
          final isDisabled = !isEnabled || isTimePassed;

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
              )
                  : ElevatedButton.styleFrom(
                backgroundColor: isDisabled ? Colors.grey[200] : Colors.white,
                foregroundColor: isDisabled ? Colors.grey : Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: isDisabled ? Colors.grey[300]! : Colors.grey),
                ),
              ),
              onPressed: isDisabled ? null : () => onSelect?.call(time),
              child: Text(time),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewButton() {
    final isPrivate = widget.room.type?.toUpperCase() == 'PRIVATE';
    final totalPrice = getTotalPrice();
    final isPriceValid = totalPrice > 0;
    final isSeatsValid = isPrivate ? true : _numberOfSeats >= 1;
    final now = DateTime.now();
    final isDateValid = !_selectedDate.isBefore(DateTime(now.year, now.month, now.day));
    final isAllDataValid = _isTimeValid && isPriceValid && isSeatsValid && isDateValid;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_isTimeValid || !isPriceValid || !isSeatsValid || !isDateValid)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                !_isTimeValid ? _timeValidationMessage :
                !isPriceValid ? 'Invalid booking duration' :
                !isSeatsValid ? 'Number of seats must be at least 1' :
                'Cannot select past dates',
                style: TextStyle(
                  color: Colors.red[300],
                  fontSize: 12,
                ),
              ),
            ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.event_seat, color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      isPrivate ? "Private Room" : "Number of Seats:",
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    if (!isPrivate) const SizedBox(width: 15),
                    if (!isPrivate) ...[
                      _buildControlButton(
                        Icons.remove,
                            () {
                          if (_numberOfSeats > 1) {
                            setState(() => _numberOfSeats--);
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '$_numberOfSeats',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      _buildControlButton(
                        Icons.add,
                            () {
                          setState(() => _numberOfSeats++);
                        },
                      ),
                    ] else ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "1",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 56,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total ${totalPrice.toStringAsFixed(1)} EGP',
                        style: TextStyle(
                          color: isAllDataValid
                              ? Colors.white
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (!isPrivate)
                        Text(
                          '${widget.discountedPrice.toStringAsFixed(1)} EGP/hour × $_numberOfSeats seats',
                          style: TextStyle(
                            color: isAllDataValid
                                ? Colors.white70
                                : Colors.grey,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (isPrivate)
                        Text(
                          '${widget.discountedPrice.toStringAsFixed(1)} EGP/hour',
                          style: TextStyle(
                            color: isAllDataValid
                                ? Colors.white70
                                : Colors.grey,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: isAllDataValid ? () {
                    context.push(
                      '/review-booking',
                      extra: {
                        'room': widget.room,
                        'selectedDate': _selectedDate,
                        'checkInTime': _checkInTime,
                        'checkOutTime': _checkOutTime,
                        'numberOfSeats': isPrivate ? 1 : _numberOfSeats,
                        'isDailyBooking': _isDailyBooking,
                        'discountedPrice': widget.discountedPrice,
                        'totalPrice': totalPrice,
                        'workspaceId': widget.workspaceId,
                      },
                    );
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAllDataValid
                        ? const Color(0xFF0A3FB3)
                        : Colors.grey[700],
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Review Booking',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    final isPrivate = widget.room.type?.toUpperCase() == 'PRIVATE';

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border.all(color: isPrivate ? Colors.grey : Colors.white, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        icon: Icon(icon, size: 14, color: isPrivate ? Colors.grey : Colors.white),
        onPressed: isPrivate ? null : onPressed,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        iconSize: 14,
      ),
    );
  }
}